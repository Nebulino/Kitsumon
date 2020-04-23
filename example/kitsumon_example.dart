/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsumon.dart';
import 'package:kitsumon/src/core/kitsu.dart';

import 'api_values.dart';

// Just an example of use.
void main() async {
  final kitsumon = Kitsumon(
      kitsu: await Kitsu.authenticate(
    username: APIValues.username,
    password: APIValues.password,
  ));
}
