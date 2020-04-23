/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:dio/dio.dart';

/// It extends [DioError] class.
/// You can find [errorCode] and [description] received from the Telegram Api.
class ApiException extends DioError {
  final String title;
  final String detail;
  final int code;
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
      '- ${title}\n'
      '- ${detail}\n'
      '- ${code}\n'
      '- ${status}';
}
