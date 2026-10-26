//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// An offline test harness for Kitsumon.
///
/// [FakeHttpClientAdapter] replaces the network layer of a [Dio] instance, so
/// everything above it (the [KitsuClient] interceptor stack, [Request], the
/// method classes) behaves exactly as shipped while nothing can ever reach
/// the network.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';

/// The JSON:API media type, as sent by and expected from Kitsu.
const String jsonApiMediaType = 'application/vnd.api+json';

/// A request as it reached the (fake) network layer.
///
/// It is recorded *after* the request interceptors ran, so it shows what would
/// have gone over the wire.
class RecordedRequest {
  /// The HTTP method, upper case (`GET`, `POST`, ...).
  final String method;

  /// The request path relative to the base URL, always with a leading `/`
  /// (for example `/edge/anime/1`).
  final String path;

  /// The full request URI, base URL and query string included.
  final Uri uri;

  /// A snapshot of the query parameters.
  final Map<String, dynamic> queryParameters;

  /// A snapshot of the request headers (keys keep their original casing).
  final Map<String, dynamic> headers;

  /// The request body as handed to the adapter (`null` when there is none).
  final dynamic data;

  RecordedRequest._({
    required this.method,
    required this.path,
    required this.uri,
    required this.queryParameters,
    required this.headers,
    required this.data,
  });

  /// Looks a header up ignoring the case of its name.
  dynamic header(String name) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == name.toLowerCase()) return entry.value;
    }
    return null;
  }

  @override
  String toString() => '$method $uri';
}

/// Thrown by [FakeHttpClientAdapter] when a request has no matching stub.
class UnstubbedRequestError extends Error {
  /// A description of the request nobody answered for.
  final String request;

  /// The stubs that were registered at the time.
  final List<String> registered;

  UnstubbedRequestError(this.request, this.registered);

  @override
  String toString() => 'UnstubbedRequestError: no stub for $request. '
      'Registered stubs: ${registered.isEmpty ? '(none)' : registered}';
}

typedef _Responder = ResponseBody Function(RequestOptions options);

/// A [HttpClientAdapter] that records requests and answers from canned
/// payloads, keyed by HTTP method and path.
///
/// A request without a matching stub throws [UnstubbedRequestError] (and is
/// still recorded in [requests]).
class FakeHttpClientAdapter implements HttpClientAdapter {
  final Map<String, _Responder> _stubs = {};

  /// Every request seen so far, in order, stubbed or not.
  final List<RecordedRequest> requests = [];

  /// Whether [close] was called.
  bool closed = false;

  /// The most recent request. Throws a [StateError] when there is none.
  RecordedRequest get lastRequest {
    if (requests.isEmpty) throw StateError('No request was recorded.');
    return requests.last;
  }

  static String _key(String method, String path) =>
      '${method.toUpperCase()} ${_normalizePath(path)}';

  static String _normalizePath(String path) =>
      path.startsWith('/') ? path : '/$path';

  /// Answers `method path` with [body] (JSON encoded unless it is already a
  /// [String]) and the given [statusCode].
  ///
  /// [path] is relative to the base URL, for example `/edge/anime`.
  void stub(
    String method,
    String path, {
    Object? body,
    int statusCode = 200,
    Map<String, List<String>>? headers,
  }) {
    _stubs[_key(method, path)] = (options) => ResponseBody.fromString(
          body is String ? body : jsonEncode(body),
          statusCode,
          headers: {
            Headers.contentTypeHeader: [jsonApiMediaType],
            ...?headers,
          },
        );
  }

  /// Answers `method path` with a JSON:API `errors[]` payload.
  ///
  /// Each entry of [errors] is a map with the usual `title`, `detail`, `code`
  /// and `status` members.
  void stubJsonApiError(
    String method,
    String path, {
    required List<Map<String, dynamic>> errors,
    int statusCode = 400,
  }) {
    stub(method, path, body: {'errors': errors}, statusCode: statusCode);
  }

  /// Makes `method path` fail at the transport level with a [DioException] of
  /// the given [type], as a real timeout would.
  void stubFailure(
    String method,
    String path, {
    DioExceptionType type = DioExceptionType.connectionTimeout,
  }) {
    _stubs[_key(method, path)] = (options) =>
        throw DioException(requestOptions: options, type: type);
  }

  /// The registered stubs, as `METHOD /path` strings.
  List<String> get registeredStubs => _stubs.keys.toList(growable: false);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final method = options.method.toUpperCase();
    final path = options.path.startsWith(RegExp(r'https?:'))
        ? options.uri.path
        : _normalizePath(options.path);

    requests.add(RecordedRequest._(
      method: method,
      path: path,
      uri: options.uri,
      queryParameters: Map<String, dynamic>.of(options.queryParameters),
      headers: Map<String, dynamic>.of(options.headers),
      data: options.data,
    ));

    final responder = _stubs[_key(method, path)];
    if (responder == null) {
      throw UnstubbedRequestError('$method ${options.uri}', registeredStubs);
    }
    return responder(options);
  }

  @override
  void close({bool force = false}) {
    closed = true;
  }
}

/// A [KitsuClient] built exactly as the package builds it, whose network layer
/// is swapped for [adapter].
///
/// Use [authentication] to exercise the `Authorization` header and [proxy] to
/// exercise the proxy configuration.
KitsuClient createFakeKitsuClient(
  FakeHttpClientAdapter adapter, {
  Authentication? authentication,
  String? proxy,
}) {
  final client = KitsuClient(authentication: authentication, proxy: proxy);
  client.dio.httpClientAdapter = adapter;
  return client;
}

/// A [KitsuClient] wrapped around a [Dio] injected by the caller, whose
/// network layer is [adapter].
///
/// Pass [dio] to control the injected instance; by default it is a bare
/// `Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))`.
KitsuClient createInjectedFakeKitsuClient(
  FakeHttpClientAdapter adapter, {
  Dio? dio,
  Authentication? authentication,
}) {
  final injected =
      dio ?? Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'));
  injected.httpClientAdapter = adapter;
  return KitsuClient(dio: injected, authentication: authentication);
}

/// A [Kitsu] session on top of a fake network layer.
///
/// With [authentication] it is built like the authenticated entry point (the
/// token is sent as a bearer header and [Kitsu.authenticated] is `true`).
Kitsu createFakeKitsu(
  FakeHttpClientAdapter adapter, {
  Authentication? authentication,
}) {
  return Kitsu.withClient(
    createFakeKitsuClient(adapter, authentication: authentication),
    authentication,
  );
}
