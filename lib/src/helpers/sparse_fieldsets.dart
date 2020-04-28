/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It helps formatting the response.
class SparseFieldSets {
  /// It indicates the object to reformat.
  String object;

  /// It indicates the only fields to be returned.
  List<String> fields;

  SparseFieldSets(this.object, this.fields);

  Map<String, dynamic> build() => {'fields[${object}]': '${fields.join(',')}'};

  @override
  String toString() => '[SparseFieldSets: ${object}] => ${fields.join(',')}';
}
