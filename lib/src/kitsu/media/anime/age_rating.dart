//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains different Age Ratings.
enum AgeRating {
  // ignore: constant_identifier_names
  G,
  // ignore: constant_identifier_names
  PG,
  // ignore: constant_identifier_names
  R,
  // ignore: constant_identifier_names
  R18;

  String get rate => switch (this) {
        AgeRating.G => 'G',
        AgeRating.PG => 'PG',
        AgeRating.R => 'R',
        AgeRating.R18 => 'R18',
      };
}
