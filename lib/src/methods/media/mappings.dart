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

/// The methods to query and retrieve Mappings from Kitsu API.
class MappingsMethods implements BaseMethod {
  @override
  final String methodRadix = 'mappings';

  @override
  final Kitsu api;

  MappingsMethods(this.api);

  /// It fetches a collection of Mappings with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [externalSite] and [externalId] match the external database record,
  /// while [itemId] and [itemType] match the local Kitsu item.
  /// A parameter that is `null` (or empty) is not sent.
  Future<MappingResults> fetchCollection({
    String? externalSite,
    String? externalId,
    int? itemId,
    String? itemType,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (externalSite != null && externalSite.isNotEmpty) {
      filters.add(Filter('externalSite', externalSite));
    }
    if (externalId != null && externalId.isNotEmpty) {
      filters.add(Filter('externalId', externalId));
    }
    if (itemId != null) {
      filters.add(Filter('itemId', itemId));
    }
    if (itemType != null && itemType.isNotEmpty) {
      filters.add(Filter('itemType', itemType));
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
    return MappingResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Mapping resource by its ID.
  Future<MappingResult> fetchResource(
    int mappingID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(mappingID);
    return MappingResult.fromJson(response as Map<String, dynamic>);
  }
}
