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

/// The methods to query and retrieve Episodes from Kitsu API.
class EpisodesMethods implements BaseMethod {
  @override
  final String methodRadix = 'episodes';

  @override
  final Kitsu api;

  EpisodesMethods(this.api);

  /// It fetches a collection of Episodes with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [mediaType] and [mediaId] match the parent media, [number] matches
  /// the episode number, and [seasonNumber] matches the season.
  /// A parameter that is `null` (or empty) is not sent.
  Future<EpisodeResults> fetchCollection({
    String? mediaType,
    int? mediaId,
    int? number,
    int? seasonNumber,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (mediaType != null && mediaType.isNotEmpty) {
      filters.add(Filter('mediaType', mediaType));
    }
    if (mediaId != null) {
      filters.add(Filter('mediaId', mediaId));
    }
    if (number != null) {
      filters.add(Filter('number', number));
    }
    if (seasonNumber != null) {
      filters.add(Filter('seasonNumber', seasonNumber));
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
    return EpisodeResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Episode resource by its ID.
  Future<EpisodeResult> fetchResource(
    int episodeID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(episodeID);
    return EpisodeResult.fromJson(response as Map<String, dynamic>);
  }
}
