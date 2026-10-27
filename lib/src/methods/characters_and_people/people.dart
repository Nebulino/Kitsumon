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

/// The methods to query and retrieve People from Kitsu API.
class PeopleMethods implements BaseMethod {
  @override
  final String methodRadix = 'people';

  @override
  final Kitsu api;

  PeopleMethods(this.api);

  /// It fetches a collection of People with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [name] and [slug] match the name and slug of the person, and [malId]
  /// matches the MyAnimeList ID. A parameter that is `null` (or empty) is not sent.
  Future<PersonResults> fetchCollection({
    String? name,
    String? slug,
    dynamic malId,
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
    if (malId != null) {
      filters.add(Filter('malId', malId));
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
    return PersonResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Person resource by its ID.
  Future<PersonResult> fetchResource(
    int personID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(personID);
    return PersonResult.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a person by its slug. Returns null if not found.
  Future<Person?> fetchBySlug(
    String slug, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final results = await fetchCollection(
      slug: slug,
      pagination: Pagination(limit: 1),
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    return results.data?.firstOrNull;
  }
}
