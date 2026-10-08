//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It implements [Exception] class.
/// You can find [description] that gives brief information of what happened.
class KitsumonException implements Exception {
  /// The description of the exception
  final String description;

  KitsumonException({String? description})
      : description = description ?? '';

  @override
  String toString() => '[KitsumonException]: $description';
}
