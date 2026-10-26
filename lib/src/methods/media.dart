//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/media/anime.dart';
import 'package:kitsumon/src/methods/media/categories.dart';
import 'package:kitsumon/src/methods/media/genres.dart';
import 'package:kitsumon/src/methods/media/manga.dart';
import 'package:kitsumon/src/methods/media/trending_manga.dart';

/// It contains all the methods related to Media.
class Media {
  /// This contains the Kitsu Object that helps connecting to the Kitsu API.
  final Kitsu _api;

  late final AnimeMethods _animeMethods;
  late final MangaMethods _mangaMethods;
  late final TrendingMangaMethods _trendingMangaMethods;
  late final CategoriesMethods _categoriesMethods;
  late final GenresMethods _genresMethods;

  Media(this._api) {
    _animeMethods = AnimeMethods(_api);
    _mangaMethods = MangaMethods(_api);
    _trendingMangaMethods = TrendingMangaMethods(_api);
    _categoriesMethods = CategoriesMethods(_api);
    _genresMethods = GenresMethods(_api);
  }

  /// Use this to access [AnimeMethods].
  AnimeMethods get anime => _animeMethods;

  /// Use this to access [MangaMethods].
  MangaMethods get manga => _mangaMethods;

  /// Use this to access [TrendingMangaMethods].
  TrendingMangaMethods get trendingManga => _trendingMangaMethods;

  /// Use this to access [CategoriesMethods].
  CategoriesMethods get categories => _categoriesMethods;

  /// Use this to access [GenresMethods].
  GenresMethods get genres => _genresMethods;
}
