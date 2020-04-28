/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/src/core/kitsu.dart';

/// This is the base of a MethodGroup
abstract class BaseMethod {
  /// This is the radix of a method.
  final String methodRadix;

  /// This is the client that helps methods connecting to [Kitsu.io] api
  ///
  /// [Kitsu.io]: https://kitsu.io/
  final Kitsu api;

  BaseMethod(
    this.methodRadix,
    this.api,
  );
}
