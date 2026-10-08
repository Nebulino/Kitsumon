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
  upcoming;

  String get status => switch (this) {
        AnimeStatus.current => 'current',
        AnimeStatus.finished => 'finished',
        AnimeStatus.tba => 'tba',
        AnimeStatus.unreleased => 'unreleased',
        AnimeStatus.upcoming => 'upcoming',
      };
}
