/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// This helps including a relationship.
class Includes {
  /// You can include related resources with include=[relationship].
  /// You can also specify successive relationships using a *.* .
  /// A comma-delimited list can be used to request multiple relationships.
  List<String> relationships;

  Includes(this.relationships);

  /// It builds the Includes object.
  Map<String, dynamic> build() => {'include': '${relationships.join(',')}'};

  @override
  String toString() => '[included] => ${relationships.join(',')}';
}
