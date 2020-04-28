/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsumon_exceptions.dart';

/// It contains all the information about pagination.
class Pagination {
  /// This indicates the limit of a page content.
  /// Resources are paginated in groups of 10 by default and can be increased to a maximum of 20.
  final int limit;

  /// This indicates the offset where the page should start
  final int offset;

  Pagination._(this.limit, this.offset);

  factory Pagination({int limit, int offset}) {
    if (limit < 0 || limit > 20) {
      throw KitsumonException(
          description: 'The limit must be greater that 0 and lower than 21.');
    }

    return Pagination._(limit, offset);
  }

  Map<String, dynamic> format() {
    var pagination = {};
    if (limit != null) {
      pagination['page[limit]'] = limit;
    }

    if (offset != null) {
      pagination['page[offset]'] = offset;
    }

    return pagination;
  }

  @override
  String toString() => '[limit] => ${limit} | [offset] => ${offset}';
}
