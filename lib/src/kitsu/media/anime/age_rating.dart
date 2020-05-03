/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It contains different Age Ratings.
enum AgeRating {
  G,
  PG,
  R,
  R18,
}

extension AgeRatingExtension on AgeRating {
  String get rate {
    switch (this) {
      case AgeRating.G:
        return 'G';
      case AgeRating.PG:
        return 'PG';
      case AgeRating.R:
        return 'R';
      case AgeRating.R18:
        return 'R18';
      default:
        return null;
    }
  }
}
