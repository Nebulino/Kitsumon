/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsumon_exceptions.dart';

/// It helps transforming values into Dart's objects.
class KitsuValueNormalizer {
  /// It transforms a Kitsu supposed seconds into a Duration.
  static Duration SecondsDurationParser(int seconds) =>
      seconds == null ? null : Duration(seconds: seconds);

  /// It transforms a Kitsu supposed unixTime into a DateTime.
  static DateTime UnixTimeDateTimeParser(int unixTime) => unixTime == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  /// It extract the *self* string that contains the link instead of creating
  /// an object just for that.
  static String ApiSelfLinkExtractor(dynamic object) {
    if (object is Map<String, dynamic>) {
      return object['self'];
    } else {
      throw KitsumonException(
          description: 'Supposed ApiSelfLink not recognized.');
    }
  }

  /// It transforms a Kitsu supposed int from a String.
  static int StringToInt(dynamic supposedInt) {
    if (supposedInt is String) {
      return int.parse(supposedInt);
    } else {
      throw KitsumonException(description: 'Supposed String not recognized.');
    }
  }
}
