//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';

/// It extends [DioException] class.
/// You can find [code] and [detail] received from the Kitsu API.
class ApiException extends DioException {
  /// The title of the API exception.
  final String title;

  /// The detail of the API exception.
  final String detail;

  /// The API code error.
  final int code;

  /// The API status.
  final int status;

  ApiException._({
    required this.title,
    required this.detail,
    required this.code,
    required this.status,
    required super.requestOptions,
    super.response,
  });

  ApiException(
    String? title,
    String? detail, {
    String? code,
    String? status,
    RequestOptions? requestOptions,
    Response? response,
  }) : this._(
          title: title ?? '',
          detail: detail ?? '',
          code: code != null ? int.tryParse(code) ?? 0 : 0,
          status: status != null ? int.tryParse(status) ?? 400 : 400,
          requestOptions: requestOptions ?? RequestOptions(path: ''),
          response: response,
        );

  @override
  String toString() => '[KitsuRestException]:\n'
      '- title:  $title\n'
      '- detail: $detail\n'
      '- code:   $code\n'
      '- status: $status';
}
