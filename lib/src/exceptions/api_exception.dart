//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';

/// It extends [DioError] class.
/// You can find [errorCode] and [description] received from the Telegram Api.
class ApiException extends DioError {
  /// The title of the API exception.
  final String title;

  /// The detail of the API exception.
  final String detail;

  /// The API code error.
  final int code;

  /// The API status.
  final int status;

  ApiException._({
    this.title,
    this.detail,
    this.code,
    this.status,
  });

  ApiException(String title, String detail, {String code, String status})
      : this._(
          title: title,
          detail: detail,
          code: int.parse(code) ?? 0,
          status: int.parse(status) ?? 400,
        );

  @override
  String toString() => '[KitsuRestException]:\n'
      '- title:  ${title}\n'
      '- detail: ${detail}\n'
      '- code:   ${code}\n'
      '- status: ${status}';
}
