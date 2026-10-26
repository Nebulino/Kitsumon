//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';

/// The default base URL of the Kitsu API.
const String _defaultBaseUrl = 'https://kitsu.io/api';

/// The JSON:API media type, used for both `Accept` and `Content-Type`.
const String _jsonApiMediaType = 'application/vnd.api+json';

/// The interceptor every [KitsuClient] registers on its [Dio] instance.
///
/// It cleans null parameters from outgoing requests and maps timeouts and
/// JSON:API `errors[]` payloads to [KitsumonException] and [ApiException].
/// It is stateless, which is what makes its registration idempotent.
class _KitsuInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.data is FormData) {
      (options.data as FormData).fields.removeWhere(
            (entry) => entry.value == 'null',
          );
      return handler.next(options);
    }

    options.queryParameters.removeWhere((key, value) => value == null);
    if (options.data == null) {
      return handler.next(options);
    }

    if (options.data is Map) {
      (options.data as Map).removeWhere((key, value) => value == null);
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: KitsumonException(description: 'Timeout Exception.'),
        ),
      );
    } else if (err.type == DioExceptionType.badResponse) {
      try {
        final dynamic responseData = err.response?.data;
        final dynamic decoded = (responseData is String)
            ? jsonDecode(responseData)
            : responseData;
        if (decoded is Map &&
            decoded['errors'] is List &&
            (decoded['errors'] as List).isNotEmpty) {
          final firstException = (decoded['errors'] as List)[0];
          return handler.reject(
            ApiException(
              firstException['title']?.toString(),
              firstException['detail']?.toString(),
              code: firstException['code']?.toString(),
              status: firstException['status']?.toString(),
              requestOptions: err.requestOptions,
              response: err.response,
            ),
          );
        }
      } catch (_) {}
      return handler.next(err);
    } else {
      return handler.next(err);
    }
  }
}

/// It creates a custom instance to send and receive requests.
class KitsuClient {
  late final Dio _dio;

  /// It exposes the internal [Dio] instance.
  Dio get dio => _dio;

  /// Creates a client.
  ///
  /// When [dio] is `null` a new [Dio] is built with the Kitsu base URL, the
  /// JSON:API `Accept`/`Content-Type` headers and, when [authentication]
  /// carries an access token, the `Authorization: Bearer` header.
  ///
  /// When [dio] is provided, the caller keeps ownership of its configuration:
  /// only the *missing* pieces are filled in (an empty `baseUrl`, absent
  /// `Accept`/`Content-Type` headers, an absent `Authorization` header when
  /// [authentication] has a token); values the caller already set are never
  /// overwritten.
  ///
  /// In both cases the same interceptor stack is registered on the [Dio]:
  /// null query/body parameters are stripped, timeouts are mapped to a
  /// [KitsumonException] (as the [DioException.error]) and JSON:API `errors[]`
  /// payloads are mapped to an [ApiException]. The interceptor is appended
  /// after any interceptor the caller already registered, so those still see
  /// the raw request and error first.
  ///
  /// Registration is idempotent: constructing several [KitsuClient]s around
  /// the same [Dio] registers the interceptor only once.
  ///
  /// [proxy] (`host:port`) routes traffic through that proxy using
  /// [HttpClient.findProxy]; TLS certificates are still fully verified. It is
  /// only applied to a [Dio] built here: when you inject your own [Dio],
  /// configure its `httpClientAdapter` yourself.
  KitsuClient({Dio? dio, Authentication? authentication, String? proxy}) {
    final token = authentication?.accessToken;

    if (dio != null) {
      _dio = dio;
      final options = _dio.options;
      if (options.baseUrl.isEmpty) {
        options.baseUrl = _defaultBaseUrl;
      }
      options.headers.putIfAbsent('Accept', () => _jsonApiMediaType);
      options.contentType ??= _jsonApiMediaType;
      if (token != null) {
        options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      }
    } else {
      final baseOptions = BaseOptions(
        baseUrl: _defaultBaseUrl,
        headers: {
          'Accept': _jsonApiMediaType,
          'Content-Type': _jsonApiMediaType,
          if (token != null) 'Authorization': 'Bearer $token',
        },
        responseType: ResponseType.json,
      );
      _dio = Dio(baseOptions);

      if (proxy != null && proxy.isNotEmpty) {
        final adapter = _dio.httpClientAdapter;
        if (adapter is IOHttpClientAdapter) {
          adapter.createHttpClient = () {
            final client = HttpClient();
            client.findProxy = (uri) => 'PROXY $proxy';
            return client;
          };
        }
      }
    }

    if (!_dio.interceptors.any((i) => i is _KitsuInterceptor)) {
      _dio.interceptors.add(_KitsuInterceptor());
    }
  }

  /// It executes the AuthMethods method.
  ///
  /// Fetch - retrieve resources
  Future<dynamic> auth({required Map<String, dynamic> body}) async {
    return (await _dio.post('/oauth/token', data: body)).data;
  }

  /// It executes a GET method.
  ///
  /// Fetch - retrieve resources
  Future<dynamic> get({
    required String method,
    Map<String, dynamic>? parameters,
  }) async {
    return (await _dio.get('/edge/$method', queryParameters: parameters)).data;
  }

  /// It executes a POST method.
  ///
  /// Create - create new resources
  Future<dynamic> post({
    required String method,
    Map<String, dynamic>? body,
  }) async {
    return (await _dio.post(method, data: body ?? {})).data;
  }

  /// It executes a PATCH method.
  ///
  /// Update - (partially) modify existing resources
  Future<dynamic> patch() async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It executes a DELETE method.
  ///
  /// Delete - remove resources
  Future<dynamic> delete() async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }
}
