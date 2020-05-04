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

///The methods about Anime Productions.
class AnimeProductions implements BaseMethod {
  @override
  final String methodRadix = 'anime-productions';

  @override
  final Kitsu api;

  AnimeProductions(this.api);

  /// It fetches the whole collection of Anime Productions.
  Future<dynamic> fetchCollection({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));

  }

  /// It fetches a particular Anime Production by his/her/its ID.
  Future<dynamic> fetchResource(
      int characterID, {
        Includes includes,
        SparseFieldSets sparseFieldSets,
      }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
}

  /// It creates a new Anime Production.
  Future<dynamic> createResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It updates an AnimeProduction.
  Future<dynamic> updateResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It deletes an Anime Production.
  Future<dynamic> deleteResource({
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }
}
