//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different roles an anime production can have.
enum AnimeProductionRole {
  licensor,
  producer,
  studio;

  String get role => switch (this) {
        AnimeProductionRole.licensor => 'licensor',
        AnimeProductionRole.producer => 'producer',
        AnimeProductionRole.studio => 'studio',
      };
}
