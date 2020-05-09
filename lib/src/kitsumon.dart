//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/characters_and_people.dart';
import 'package:meta/meta.dart';

/// This connects all the various methods [Kitsu] can provide.
///
/// [Kitsu]: https://kitsu.io/
class Kitsumon {
  /// The Kitsumon instance.
  static Kitsumon _instance;

  /// The [Kitsu] object. Helps creating each methods.
  final Kitsu _api;

  CharactersAndPeople _charactersAndPeople;

  Kitsumon._(this._api) {
    _instance = this;
    _charactersAndPeople = CharactersAndPeople(_api);
  }

  /// It creates the Kitsumon instance.
  Kitsumon({@required Kitsu kitsu}) : this._(kitsu);

  /// It returns the Api associated with this instance of Kitsumon.
  Kitsu get api => _api;

  CharactersAndPeople get charactersAndPeople => _charactersAndPeople;
}
