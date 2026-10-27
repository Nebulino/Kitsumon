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

/// The methods to query and retrieve Streaming Links from Kitsu API.
class StreamingLinksMethods implements BaseMethod {
  @override
  final String methodRadix = 'streaming-links';

  @override
  final Kitsu api;

  StreamingLinksMethods(this.api);

  /// It fetches a collection of Streaming Links with optional filters,
  /// pagination, sorting, includes and sparse fieldsets.
  ///
  /// [mediaType] and [mediaId] match the target media, and [streamerId]
  /// matches the streamer service. A parameter that is `null` (or empty)
  /// is not sent.
  Future<StreamingLinkResults> fetchCollection({
    String? mediaType,
    int? mediaId,
    int? streamerId,
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
    if (streamerId != null) {
      filters.add(Filter('streamerId', streamerId));
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
    return StreamingLinkResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Streaming Link resource by its ID.
  Future<StreamingLinkResult> fetchResource(
    int streamingLinkId, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(streamingLinkId);
    return StreamingLinkResult.fromJson(response as Map<String, dynamic>);
  }
}
