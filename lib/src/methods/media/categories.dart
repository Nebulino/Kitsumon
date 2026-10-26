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

/// The methods to query and retrieve Categories from Kitsu API.
class CategoriesMethods implements BaseMethod {
  @override
  final String methodRadix = 'categories';

  @override
  final Kitsu api;

  CategoriesMethods(this.api);

  /// It fetches a collection of Categories with optional filters, pagination,
  /// sorting, includes and sparse fieldsets.
  ///
  /// [title] and [slug] match the title and the slug of a category, [parent]
  /// matches the categories whose parent has that slug. A parameter that is
  /// `null` (or empty) is not sent.
  Future<CategoryResults> fetchCollection({
    String? title,
    String? slug,
    String? parent,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (title != null && title.isNotEmpty) {
      filters.add(Filter('title', title));
    }
    if (slug != null && slug.isNotEmpty) {
      filters.add(Filter('slug', slug));
    }
    if (parent != null && parent.isNotEmpty) {
      filters.add(Filter('parent', parent));
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
    return CategoryResults.fromJson(response as Map<String, dynamic>);
  }

  /// It fetches a single Category resource by its ID.
  Future<CategoryResult> fetchResource(
    int categoryID, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(categoryID);
    return CategoryResult.fromJson(response as Map<String, dynamic>);
  }
}
