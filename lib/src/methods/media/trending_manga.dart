/*
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/core/request.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:kitsumon/src/helpers/pagination.dart';
import 'package:kitsumon/src/helpers/sparse_fieldsets.dart';
import 'package:kitsumon/src/methods/core/base_method.dart';

/// The methods to retrieve the Manga currently trending on Kitsu.
class TrendingMangaMethods implements BaseMethod {
  @override
  final String methodRadix = 'trending/manga';

  @override
  final Kitsu api;

  TrendingMangaMethods(this.api);

  /// It fetches the currently trending Manga on Kitsu.
  ///
  /// The trending endpoint answers without a `meta` block and without
  /// pagination links, so only the manga are returned. The list is empty when
  /// nothing is trending.
  Future<List<Manga>> fetchTrending({
    Pagination? pagination,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      pagination: pagination,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.get();
    final results = MangaResults.fromJson(response as Map<String, dynamic>);
    return results.data ?? <Manga>[];
  }
}
