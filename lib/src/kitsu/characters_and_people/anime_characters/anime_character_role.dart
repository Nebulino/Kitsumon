/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It contains different roles an anime character can have.
enum AnimeCharacterRole {
  main,
  supporting,
}

extension AnimeCharacterRoleExtension on AnimeCharacterRole {
  String get role {
    switch (this) {
      case AnimeCharacterRole.main:
        return 'main';
      case AnimeCharacterRole.supporting:
        return 'supporting';
      default:
        return null;
    }
  }
}
