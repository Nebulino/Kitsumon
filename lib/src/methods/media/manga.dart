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

/// The methods to query and retrieve Manga from Kitsu API.
class MangaMethods implements BaseMethod {
  @override
  final String methodRadix = 'manga';

  @override
  final Kitsu api;

  MangaMethods(this.api);

  /// It fetches a collection of Manga with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [categories] and [genres] are the slugs of the categories and genres to
  /// match. A parameter that is `null` (or empty) is not sent.
  Future<MangaResults> fetchCollection({
    String? text,
    List<MangaSubtype>? subtypes,
    List<MangaStatus>? status,
    List<String>? categories,
    List<String>? genres,
    List<int>? ids,
    String? slug,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (text != null && text.isNotEmpty) {
      filters.add(Filter('text', text));
    }
    if (subtypes != null && subtypes.isNotEmpty) {
      filters.add(Filter('subtype', subtypes.map((s) => s.type).join(',')));
    }
    if (status != null && status.isNotEmpty) {
      filters.add(Filter('status', status.map((s) => s.status).join(',')));
    }
    if (categories != null && categories.isNotEmpty) {
      filters.add(Filter('categories', categories.join(',')));
    }
    if (genres != null && genres.isNotEmpty) {
      filters.add(Filter('genres', genres.join(',')));
    }
    if (ids != null && ids.isNotEmpty) {
      filters.add(Filter('id', ids.join(',')));
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
    return MangaResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Manga resource by its ID.
  Future<MangaResult> fetchResource(
    int mangaID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(mangaID);
    return MangaResult.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a manga by its slug. Returns null if not found.
  Future<Manga?> fetchBySlug(
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
