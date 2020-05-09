//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different Anime Subtypes.
enum AnimeSubtype {
  ONA,
  OVA,
  TV,
  movie,
  music,
  special,
}

extension AnimeSubtypeExtension on AnimeSubtype {
  String get type {
    switch (this) {
      case AnimeSubtype.ONA:
        return 'ONA';
      case AnimeSubtype.OVA:
        return 'OVA';
      case AnimeSubtype.TV:
        return 'TV';
      case AnimeSubtype.movie:
        return 'movie';
      case AnimeSubtype.music:
        return 'music';
      case AnimeSubtype.special:
        return 'special';
      default:
        return null;
    }
  }
}
