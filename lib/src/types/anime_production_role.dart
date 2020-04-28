/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It contains different roles an anime production can have.
enum AnimeProductionRole { licensor, producer, studio }

extension AnimeProductionRoleExtension on AnimeProductionRole {
  String get role {
    switch (this) {
      case AnimeProductionRole.licensor:
        return 'licensor';
      case AnimeProductionRole.producer:
        return 'producer';
      case AnimeProductionRole.studio:
        return 'studio';
      default:
        return null;
    }
  }
}
