//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/characters_and_people.dart';
import 'package:kitsumon/src/methods/media.dart';
import 'package:kitsumon/src/methods/user_libraries/library_entries.dart';
import 'package:kitsumon/src/methods/users/users.dart';

/// This connects all the various methods [Kitsu] can provide.
///
/// [Kitsu]: https://kitsu.io/
class Kitsumon {
  /// The Kitsumon instance.
  static Kitsumon? _instance;

  /// The [Kitsu] object. Helps creating each methods.
  final Kitsu _api;

  late final CharactersAndPeople _charactersAndPeople;
  late final Media _media;
  late final UsersMethods _users;
  late final LibraryEntriesMethods _libraryEntries;

  Kitsumon._(this._api) {
    _instance = this;
    _charactersAndPeople = CharactersAndPeople(_api);
    _media = Media(_api);
    _users = UsersMethods(_api);
    _libraryEntries = LibraryEntriesMethods(_api);
  }

  /// It creates the Kitsumon instance.
  Kitsumon({required Kitsu kitsu}) : this._(kitsu);

  /// It returns the current instance of Kitsumon.
  static Kitsumon? get instance => _instance;

  /// It returns the Api associated with this instance of Kitsumon.
  Kitsu get api => _api;

  CharactersAndPeople get charactersAndPeople => _charactersAndPeople;

  Media get media => _media;

  /// Use this to access the [UsersMethods] of the session.
  UsersMethods get users => _users;

  /// Use this to access the [LibraryEntriesMethods] of the session.
  LibraryEntriesMethods get libraryEntries => _libraryEntries;
}
