//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

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

/// The methods to query and retrieve Anime from Kitsu API.
class AnimeMethods implements BaseMethod {
  @override
  final String methodRadix = 'anime';

  @override
  final Kitsu api;

  AnimeMethods(this.api);

  /// It fetches a collection of Anime with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  Future<AnimeResults> fetchCollection({
    String? text,
    String? season,
    int? seasonYear,
    List<AnimeSubtype>? subtypes,
    List<AnimeStatus>? status,
    List<AgeRating>? ageRatings,
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
    if (season != null && season.isNotEmpty) {
      filters.add(Filter('season', season));
    }
    if (seasonYear != null) {
      filters.add(Filter('seasonYear', seasonYear));
    }
    if (subtypes != null && subtypes.isNotEmpty) {
      filters.add(Filter('subtype', subtypes.map((s) => s.type).join(',')));
    }
    if (status != null && status.isNotEmpty) {
      filters.add(Filter('status', status.map((s) => s.status).join(',')));
    }
    if (ageRatings != null && ageRatings.isNotEmpty) {
      filters.add(Filter('ageRating', ageRatings.map((r) => r.rate).join(',')));
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
    return AnimeResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Anime resource by its ID.
  Future<AnimeResult> fetchResource(
    int animeID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(animeID);
    return AnimeResult.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches an anime by its slug. Returns null if not found.
  Future<Anime?> fetchBySlug(
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

  /// It fetches the currently trending Anime on Kitsu.
  Future<AnimeResults> fetchTrending({
    Pagination? pagination,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final parameters = <String, dynamic>{};
    if (pagination != null) parameters.addAll(pagination.format());
    if (includes != null) parameters.addAll(includes.build());
    if (sparseFieldSets != null) parameters.addAll(sparseFieldSets.build());

    final response = await api.client.get(
      method: 'trending/anime',
      parameters: parameters.isNotEmpty ? parameters : null,
    );

    final dynamic data = (response is String) ? jsonDecode(response) : response;
    return AnimeResults.fromJson(data as Map<String, dynamic>);
  }

  /// It creates a new Anime resource.
  Future<dynamic> createResource({
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It updates an Anime resource.
  Future<dynamic> updateResource({
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It deletes an Anime resource.
  Future<dynamic> deleteResource({
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }
}