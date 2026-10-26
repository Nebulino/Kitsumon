//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:json_annotation/json_annotation.dart';

/// It contains different Manga Subtypes.
enum MangaSubtype {
  manga,
  novel,
  @JsonValue('one_shot')
  oneShot,
  doujin,
  manhua,
  oel,
  manhwa;

  /// The value the API uses for this subtype.
  String get type => switch (this) {
        MangaSubtype.manga => 'manga',
        MangaSubtype.novel => 'novel',
        MangaSubtype.oneShot => 'one_shot',
        MangaSubtype.doujin => 'doujin',
        MangaSubtype.manhua => 'manhua',
        MangaSubtype.oel => 'oel',
        MangaSubtype.manhwa => 'manhwa',
      };
}
