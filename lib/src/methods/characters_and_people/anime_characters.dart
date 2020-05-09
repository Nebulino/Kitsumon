//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

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

///The methods about Anime Characters.
class AnimeCharactersMethods implements BaseMethod {
  @override
  final String methodRadix = 'anime-characters';

  @override
  final Kitsu api;

  AnimeCharactersMethods(this.api);

  /// It fetches the whole collection of Anime Characters.
  Future<AnimeCharactersResults> fetchCollection({
    List<int> animeID,
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    final request = Request(
      this,
      filters: [Filter('animeId', animeID)],
      pagination: pagination,
      sorting: sorting,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    return AnimeCharactersResults.fromJson(await request.get());
  }

  /// It fetches a particular Character by his/her/its ID.
  Future<AnimeCharacterResult> fetchResource(
    int characterID, {
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    return AnimeCharacterResult.fromJson(await request.fetch(characterID));
  }

  /// It creates a new Anime Character.
  Future<dynamic> createResource({
    List<int> animeID,
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It updates a new Anime Character.
  Future<dynamic> updateResource({
    List<int> animeID,
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }

  /// It deletes an Anime Character.
  Future<dynamic> deleteResource({
    List<int> animeID,
    Pagination pagination,
    Sorting sorting,
    Includes includes,
    SparseFieldSets sparseFieldSets,
  }) async {
    return Future.error(KitsumonException(description: 'Not Yet Implemented.'));
  }
}
