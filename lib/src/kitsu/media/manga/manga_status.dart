//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different Manga statuses.
enum MangaStatus {
  current,
  finished,
  tba,
  unreleased,
  upcoming;

  /// The value the API uses for this status.
  String get status => switch (this) {
        MangaStatus.current => 'current',
        MangaStatus.finished => 'finished',
        MangaStatus.tba => 'tba',
        MangaStatus.unreleased => 'unreleased',
        MangaStatus.upcoming => 'upcoming',
      };
}
