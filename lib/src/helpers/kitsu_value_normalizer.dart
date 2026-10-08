//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon_exceptions.dart';

/// It helps transforming values into Dart's objects.
class KitsuValueNormalizer {
  /// It transforms a Kitsu supposed seconds into a Duration.
  static Duration? secondsDurationParser(dynamic seconds) {
    if (seconds == null) return null;
    if (seconds is int) return Duration(seconds: seconds);
    if (seconds is num) return Duration(seconds: seconds.toInt());
    return null;
  }

  // ignore: non_constant_identifier_names
  static Duration? SecondsDurationParser(dynamic seconds) =>
      secondsDurationParser(seconds);

  /// It transforms a Kitsu supposed unixTime into a DateTime.
  static DateTime? unixTimeDateTimeParser(dynamic unixTime) {
    if (unixTime == null) return null;
    if (unixTime is int) {
      return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    }
    if (unixTime is num) {
      return DateTime.fromMillisecondsSinceEpoch(unixTime.toInt() * 1000);
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  static DateTime? UnixTimeDateTimeParser(dynamic unixTime) =>
      unixTimeDateTimeParser(unixTime);

  /// It extract the *self* string that contains the link instead of creating
  /// an object just for that.
  static String? apiSelfLinkExtractor(dynamic object) {
    if (object == null) return null;
    if (object is Map) {
      final self = object['self'];
      return self?.toString();
    } else {
      throw KitsumonException(
          description: 'Supposed ApiSelfLink not recognized.');
    }
  }

  // ignore: non_constant_identifier_names
  static String? ApiSelfLinkExtractor(dynamic object) =>
      apiSelfLinkExtractor(object);

  /// It transforms a Kitsu supposed int from a String or number.
  static int? stringToInt(dynamic supposedInt) {
    if (supposedInt == null) return null;
    if (supposedInt is int) return supposedInt;
    if (supposedInt is num) return supposedInt.toInt();
    if (supposedInt is String) return int.tryParse(supposedInt);
    throw KitsumonException(description: 'Supposed String not recognized.');
  }

  // ignore: non_constant_identifier_names
  static int? StringToInt(dynamic supposedInt) => stringToInt(supposedInt);
}
