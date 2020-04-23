/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

/// It helps transforming values into Dart's objects.
class KitsuValueNormalizer {
  /// It transforms a Kitsu supposed seconds into a Duration.
  static Duration SecondsDurationParser(int seconds) =>
      seconds == null ? null : Duration(seconds: seconds);

  /// It transforms a Kitsu supposed unixTime into a DateTime.
  static DateTime UnixTimeDateTimeParser(int unixTime) => unixTime == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
}
