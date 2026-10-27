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

/// The methods to query and retrieve Chapters from Kitsu API.
class ChaptersMethods implements BaseMethod {
  @override
  final String methodRadix = 'chapters';

  @override
  final Kitsu api;

  ChaptersMethods(this.api);

  /// It fetches a collection of Chapters with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [mangaId] matches the parent manga, [number] matches the chapter number,
  /// and [volumeNumber] matches the volume. A parameter that is `null` (or empty)
  /// is not sent.
  Future<ChapterResults> fetchCollection({
    int? mangaId,
    int? number,
    int? volumeNumber,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (mangaId != null) {
      filters.add(Filter('mangaId', mangaId));
    }
    if (number != null) {
      filters.add(Filter('number', number));
    }
    if (volumeNumber != null) {
      filters.add(Filter('volumeNumber', volumeNumber));
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
    return ChapterResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Chapter resource by its ID.
  Future<ChapterResult> fetchResource(
    int chapterID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(chapterID);
    return ChapterResult.fromJson(response as Map<String, dynamic>);
  }
}
