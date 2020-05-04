/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';
import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/core/request.dart';
import 'package:kitsumon/src/helpers/filter.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:kitsumon/src/helpers/pagination.dart';
import 'package:kitsumon/src/helpers/sorting.dart';
import 'package:kitsumon/src/helpers/sparse_fieldsets.dart';
import 'package:kitsumon/src/methods/core/base_method.dart';

///The methods about Castings.
class Castings implements BaseMethod {
  @override
  final String methodRadix = 'castings';

  @override
  final Kitsu api;

  Castings(this.api);

  /// It fetches the whole collection of Castings.
  Future<dynamic> fetchCollection({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It fetches a particular Casting by his/her/its ID.
  Future<dynamic> fetchResource(
      int characterID, {
        Includes includes,
        SparseFieldSets sparseFieldSets,
      }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It creates a new Castings.
  Future<dynamic> createResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It updates a Castings.
  Future<dynamic> updateResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It deletes a Castings.
  Future<dynamic> deleteResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }
}
