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

/// It creates a custom instance to send and receive requests.
class KitsuClient {
  late final Dio _dio;

  /// It exposes the internal [Dio] instance.
  Dio get dio => _dio;

  KitsuClient({Dio? dio, Authentication? authentication, String? proxy}) {
    if (dio != null) {
      _dio = dio;
      return;
    }

    final baseOptions = BaseOptions(
      baseUrl: 'https://kitsu.io/api',
      headers: {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
        if (authentication?.accessToken != null)
          'Authorization': 'Bearer ${authentication!.accessToken}',
      },
      responseType: ResponseType.json,
    );

    _dio = Dio(baseOptions)
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
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
          },
          onResponse: (response, handler) {
            return handler.next(response);
          },
          onError: (error, handler) {
            if (error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.connectionTimeout) {
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: KitsumonException(description: 'Timeout Exception.'),
                ),
              );
            } else if (error.type == DioExceptionType.badResponse) {
              try {
                final dynamic responseData = error.response?.data;
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
                      requestOptions: error.requestOptions,
                      response: error.response,
                    ),
                  );
                }
              } catch (_) {}
              return handler.next(error);
            } else {
              return handler.next(error);
            }
          },
        ),
      );

    if (proxy != null && proxy.isNotEmpty) {
      final adapter = _dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.findProxy = (uri) => 'PROXY $proxy';
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
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
