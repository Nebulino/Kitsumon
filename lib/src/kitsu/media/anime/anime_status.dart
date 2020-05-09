//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different Anime statuses.
enum AnimeStatus {
  current,
  finished,
  tba,
  unreleased,
  upcoming,
}

extension AnimeStatusExtension on AnimeStatus {
  String get status {
    switch (this) {
      case AnimeStatus.current:
        return 'current';
      case AnimeStatus.finished:
        return 'finished';
      case AnimeStatus.tba:
        return 'tba';
      case AnimeStatus.unreleased:
        return 'unreleased';
      case AnimeStatus.upcoming:
        return 'upcoming';
      default:
        return null;
    }
  }
}
