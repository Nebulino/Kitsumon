//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

import 'package:kitsumon/kitsumon.dart';

// Just an example of use.
void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  print('animeCharacters.fetchCollection()');
  final animeCharacters =
      await kitsumon.charactersAndPeople.animeCharacters.fetchCollection(
    animeID: [
      11614,
      42028,
    ],
    includes: Includes(['anime', 'character', 'castings']),
  );
  print(const JsonEncoder.withIndent('  ').convert(animeCharacters.toJson()));

  print('animeCharacters.fetchResource()');
  final animeCharacter =
      await kitsumon.charactersAndPeople.animeCharacters.fetchResource(
    11614,
    includes: Includes(['anime']),
  );
  print(const JsonEncoder.withIndent('  ').convert(animeCharacter.toJson()));
}
