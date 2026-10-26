/*
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/core/request.dart';
import 'package:kitsumon/src/helpers/filter.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:kitsumon/src/helpers/pagination.dart';
import 'package:kitsumon/src/helpers/sorting.dart';
import 'package:kitsumon/src/helpers/sparse_fieldsets.dart';
import 'package:kitsumon/src/methods/core/base_method.dart';

/// The methods to query and retrieve Genres from Kitsu API.
class GenresMethods implements BaseMethod {
  @override
  final String methodRadix = 'genres';

  @override
  final Kitsu api;

  GenresMethods(this.api);

  /// It fetches a collection of Genres with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [name] and [slug] match the name and the slug of a genre. A parameter
  /// that is `null` (or empty) is not sent.
  Future<GenreResults> fetchCollection({
    String? name,
    String? slug,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (name != null && name.isNotEmpty) {
      filters.add(Filter('name', name));
    }
    if (slug != null && slug.isNotEmpty) {
      filters.add(Filter('slug', slug));
    }
    if (customFilters != null && customFilters.isNotEmpty) {
      filters.addAll(customFilters);
    }

    final request = Request(
      this,
      filters: filters.isNotEmpty ? filters : null,
      pagination: pagination,
      sorting: sorting,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.get();
    return GenreResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Genre resource by its ID.
  Future<GenreResult> fetchResource(
    int genreID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(genreID);
    return GenreResult.fromJson(response as Map<String, dynamic>);
  }
}
