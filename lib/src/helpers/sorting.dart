/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It contains all the information about sorting.
///
/// Sorting by attributes is also supported.
/// By default, sorts are applied in ascending order.
/// You can request a descending order by prepending **-** to the parameter.
/// You can use a comma-delimited list to sort by multiple attributes.
class Sorting {
  /// This is a list of attributes for sorting
  final String sortingAttribute;

  /// This is a bool for controlling if is descending or ascending.
  final bool descending;

  Sorting(this.sortingAttribute, {this.descending});

  @override
  String toString() => descending ? '-' : '' + sortingAttribute;
}
