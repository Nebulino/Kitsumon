//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/characters_and_people/anime_characters.dart';

/// It contains all the methods related to Characters and People.
class CharactersAndPeople {
  /// This contains the Kitsu Object that helps connecting to the Kitsu API.
  final Kitsu _api;

  AnimeCharactersMethods _animeCharactersMethods;

  CharactersAndPeople(this._api) {
    _animeCharactersMethods = AnimeCharactersMethods(_api);
  }

  /// Use this to use [AnimeCharactersMethods].
  AnimeCharactersMethods get animeCharacters => _animeCharactersMethods;

  /// Use this to use [AnimeProductionsMethods].
}
