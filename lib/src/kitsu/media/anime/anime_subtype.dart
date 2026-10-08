//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different Anime Subtypes.
enum AnimeSubtype {
  // ignore: constant_identifier_names
  ONA,
  // ignore: constant_identifier_names
  OVA,
  // ignore: constant_identifier_names
  TV,
  movie,
  music,
  special;

  String get type => switch (this) {
        AnimeSubtype.ONA => 'ONA',
        AnimeSubtype.OVA => 'OVA',
        AnimeSubtype.TV => 'TV',
        AnimeSubtype.movie => 'movie',
        AnimeSubtype.music => 'music',
        AnimeSubtype.special => 'special',
      };
}
