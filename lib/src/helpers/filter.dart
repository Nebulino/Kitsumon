/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// This is a filter, it lets you query data that contains certain matching
/// attributes or relationships.
class Filter {
  /// This is the name of the filter, the attribute that filters the query.
  String attribute;

  /// This is the filter query.
  dynamic value;

  Filter(this.attribute, this.value);

  Map<String, dynamic> format() {
    if (value == null) {
      return null;
    }

    if (!(value is List)) {
      return {'filter[${attribute}]': value};
    } else {
      return {'filter[${attribute}]': '${value.join(',')}'};
    }
  }

  @override
  String toString() => '[${attribute}] => ${value}';
}
