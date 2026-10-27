//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/media/anime.dart';
import 'package:kitsumon/src/methods/media/categories.dart';
import 'package:kitsumon/src/methods/media/chapters.dart';
import 'package:kitsumon/src/methods/media/episodes.dart';
import 'package:kitsumon/src/methods/media/genres.dart';
import 'package:kitsumon/src/methods/media/manga.dart';
import 'package:kitsumon/src/methods/media/mappings.dart';
import 'package:kitsumon/src/methods/media/streaming_links.dart';
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
  late final EpisodesMethods _episodesMethods;
  late final ChaptersMethods _chaptersMethods;
  late final StreamingLinksMethods _streamingLinksMethods;
  late final MappingsMethods _mappingsMethods;

  Media(this._api) {
    _animeMethods = AnimeMethods(_api);
    _mangaMethods = MangaMethods(_api);
    _trendingMangaMethods = TrendingMangaMethods(_api);
    _categoriesMethods = CategoriesMethods(_api);
    _genresMethods = GenresMethods(_api);
    _episodesMethods = EpisodesMethods(_api);
    _chaptersMethods = ChaptersMethods(_api);
    _streamingLinksMethods = StreamingLinksMethods(_api);
    _mappingsMethods = MappingsMethods(_api);
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

  /// Use this to access [EpisodesMethods].
  EpisodesMethods get episodes => _episodesMethods;

  /// Use this to access [ChaptersMethods].
  ChaptersMethods get chapters => _chaptersMethods;

  /// Use this to access [StreamingLinksMethods].
  StreamingLinksMethods get streamingLinks => _streamingLinksMethods;

  /// Use this to access [MappingsMethods].
  MappingsMethods get mappings => _mappingsMethods;
}
