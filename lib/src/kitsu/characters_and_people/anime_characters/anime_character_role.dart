//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different roles an anime character can have.
enum AnimeCharacterRole {
  main,
  supporting;

  String get role => switch (this) {
        AnimeCharacterRole.main => 'main',
        AnimeCharacterRole.supporting => 'supporting',
      };
}
