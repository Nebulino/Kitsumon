//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It implements [Exception] class.
/// You can find [description] that gives a brief information of what happened.
class KitsumonException implements Exception {
  /// The description of the exception
  final String _description;

  KitsumonException._(this._description);

  KitsumonException({String description}) : this._(description);

  @override
  String toString() =>
      '[KitsumonException]' + (_description != null ? ': ${_description}' : '');
}
