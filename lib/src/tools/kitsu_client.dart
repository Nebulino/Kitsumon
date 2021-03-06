//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';
import 'package:meta/meta.dart';

/// It creates a custom instance to send and receive requests.
class KitsuClient {
  /// KitsuClient uses Dio.
  Dio _dio;

  KitsuClient({Authentication authentication, String proxy}) {
    var baseOptions;

    if (authentication != null) {
      baseOptions = BaseOptions(
          baseUrl: 'https://kitsu.io/api',
          headers: {
            'Accept': 'application/vnd.api+json',
            'Content-Type': 'application/vnd.api+json',
            'Authorization': 'Bearer ${authentication.accessToken}'
          },
          responseType: ResponseType.json);
    } else {
      baseOptions = BaseOptions(
          baseUrl: 'https://kitsu.io/api',
          headers: {
            'Accept': 'application/vnd.api+json',
            'Content-Type': 'application/vnd.api+json',
          },
          responseType: ResponseType.json);
    }

    _dio = Dio(
      baseOptions,
    )..interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        if (options.data is FormData) {
          (options.data as FormData).fields
            ..removeWhere((map_entry) => map_entry.value == null)
            ..removeWhere((map_entry) => map_entry.value == 'null');
          return options;
        }

        options.queryParameters?.removeWhere((key, value) => value == null);
        if (options.data == null) {
          return options;
        }

        if (options.data is Map) {
          (options.data as Map).removeWhere((key, value) => value == null);
        }

        return options;
      }, onResponse: (response) {
        return response.data;
      }, onError: (error) {
        if (error.type == DioErrorType.RECEIVE_TIMEOUT ||
            error.type == DioErrorType.CONNECT_TIMEOUT) {
          return KitsumonException(description: 'Timeout Exception.');
          // or retry?
        } else if (error.type == DioErrorType.RESPONSE) {
          final firstException = jsonDecode(error.response.data)['errors'][0];

          // It can throws multiple exceptions, but I better give the first one for now.
          return ApiException(
            firstException['title'],
            firstException['detail'],
            code: firstException['code'],
            status: firstException['status'],
          );
        } else {
          return error;
        }
      }));

    if (proxy != null) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) => 'PROXY ${proxy}';
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /// It executes the AuthMethods method.
  ///
  /// Fetch - retrieve resources
  Future<dynamic> auth({@required Map<String, dynamic> body}) async {
    return (await _dio.post('/oauth/token', data: body ?? {})).data;
  }

  /// It executes a GET method.
  ///
  /// Fetch - retrieve resources
  Future<dynamic> get(
      {@required String method, Map<String, dynamic> parameters}) async {
    return (await _dio.get('/edge/${method}', queryParameters: parameters))
        .data;
  }

  /// It executes a POST method.
  ///
  /// Create - create new resources
  Future<dynamic> post(
      {@required String method, Map<String, dynamic> body}) async {
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
