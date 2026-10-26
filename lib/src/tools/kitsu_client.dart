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

/// Key placed in [RequestOptions.extra] to mark a request that was already
/// retried after an HTTP 401 response.
void _setBearerHeader(Map<String, dynamic> headers, String token) {
  // dio keeps its headers in a case-insensitive map, so this assignment
  // replaces an existing `Authorization` instead of adding a second one.
  // Do not `removeWhere` first: removing a key from that map and writing
  // again trips a key cast inside `dio`.
  headers['Authorization'] = 'Bearer $token';
}

/// The interceptor every [KitsuClient] registers on its [Dio] instance.
///
/// It cleans null parameters from outgoing requests, refreshes expired bearer
/// tokens once on HTTP 401 when [KitsuClient.onUnauthorized] is set, and maps
/// timeouts and JSON:API `errors[]` payloads to [KitsumonException] and
/// [ApiException].
class _KitsuInterceptor extends Interceptor {
  KitsuClient _client;

  _KitsuInterceptor(this._client);

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
    }

    if (err.type == DioExceptionType.badResponse) {
      return _rejectBadResponse(err, handler);
    }

    return handler.next(err);
  }

  void _rejectBadResponse(DioException err, ErrorInterceptorHandler handler) {
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
  }
}

/// HTTP client configured for the Kitsu JSON:API and OAuth2 endpoints.
class KitsuClient {
  late final Dio _dio;

  /// Callback invoked at most once per request on an HTTP 401 response to
  /// obtain a refreshed [Authentication] and retry the failed request once.
  Future<Authentication?> Function()? onUnauthorized;

  /// The underlying [Dio] instance used by this client.
  Dio get dio => _dio;

  /// Creates a [KitsuClient].
  ///
  /// When [dio] is `null`, a new [Dio] is built with the Kitsu base URL, the
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
  /// [KitsumonException] (as the [DioException.error]), HTTP 401 responses
  /// invoke [onUnauthorized] once to refresh and retry once, and JSON:API
  /// `errors[]` payloads are mapped to an [ApiException]. The interceptor is
  /// appended after any interceptor the caller already registered, so those
  /// still see the raw request and error first.
  ///
  /// Registration is idempotent: constructing several [KitsuClient]s around
  /// the same [Dio] registers the interceptor only once.
  ///
  /// [proxy] (`host:port`) routes traffic through that proxy using
  /// [HttpClient.findProxy]; TLS certificates are still fully verified. It is
  /// only applied to a [Dio] built here: when you inject your own [Dio],
  /// configure its `httpClientAdapter` yourself.
  KitsuClient({
    Dio? dio,
    Authentication? authentication,
    String? proxy,
    this.onUnauthorized,
  }) {
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

    final existing =
        _dio.interceptors.whereType<_KitsuInterceptor>().firstOrNull;
    if (existing != null) {
      if (onUnauthorized != null || existing._client.onUnauthorized == null) {
        existing._client = this;
      }
    } else {
      _dio.interceptors.add(_KitsuInterceptor(this));
    }
  }

  /// Sends a `POST` request with [body] to `/oauth/token`.
  Future<dynamic> auth({required Map<String, dynamic> body}) async {
    return (await _dio.post('/oauth/token', data: body)).data;
  }

  /// Sends a `GET` request to `/edge/<method>` with optional [parameters].
  Future<dynamic> get({
    required String method,
    Map<String, dynamic>? parameters,
  }) async {
    return (await _send(
      () => _dio.get('/edge/$method', queryParameters: parameters),
    ))
        .data;
  }

  /// Sends a `POST` request to `/edge/<method>` with optional [body].
  Future<dynamic> post({
    required String method,
    Map<String, dynamic>? body,
  }) async {
    return (await _send(
      () => _dio.post('/edge/$method', data: body ?? <String, dynamic>{}),
    ))
        .data;
  }

  /// Sends a `PATCH` request to `/edge/<method>` with optional [body].
  Future<dynamic> patch({
    required String method,
    Map<String, dynamic>? body,
  }) async {
    return (await _send(
      () => _dio.patch('/edge/$method', data: body ?? <String, dynamic>{}),
    ))
        .data;
  }

  /// Sends a `DELETE` request to `/edge/<method>`.
  Future<dynamic> delete({required String method}) async {
    return (await _send(() => _dio.delete('/edge/$method'))).data;
  }

  /// Runs [request] and, on a 401, refreshes once through [onUnauthorized],
  /// updates the bearer header and runs the very same request one more time.
  ///
  /// A second 401 is not retried: the caller gets the original error, so two
  /// consecutive 401s cannot loop.
  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      final callback = onUnauthorized;
      if (error.response?.statusCode != 401 || callback == null) {
        rethrow;
      }

      final refreshed = await callback();
      final token = refreshed?.accessToken;
      if (token == null || token.isEmpty) {
        rethrow;
      }

      _setBearerHeader(_dio.options.headers, token);
      return request();
    }
  }
}
