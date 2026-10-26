//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// Loads the real Kitsu responses saved under `test/fixtures/`.
library;

import 'dart:convert';
import 'dart:io';

/// Reads `test/fixtures/<name>` (relative to the package root, where
/// `dart test` runs) and decodes it.
///
/// Every call decodes the file again, so a test may mutate its copy.
Map<String, dynamic> loadFixture(String name) {
  final file = File('test/fixtures/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}
