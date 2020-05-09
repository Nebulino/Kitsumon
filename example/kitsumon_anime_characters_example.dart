//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:nebby_dart_utils/helpers.dart';

import 'api_helper.dart';

// Just an example of use.
void main() async {
  final kitsumon = Kitsumon(
      kitsu: await Kitsu.authenticate(
    username: APIValues.username,
    password: APIValues.password,
  ));

  print('animeCharacters.fetchCollection()');
  await kitsumon.charactersAndPeople.animeCharacters.fetchCollection(
    animeID: [
      11614,
      42028,
    ],
    includes: Includes(['anime', 'character', 'castings']),
  ).then(
      (animeCharacters) => PrettyPrinter.prettyPrint(animeCharacters.toJson()));

  print('animeCharacters.fetchResource()');
  await kitsumon.charactersAndPeople.animeCharacters
      .fetchResource(
        11614,
        includes: Includes(['anime']),
        // sparseFieldSets: SparseFieldSets('anime', ['createdAt']),
      )
      .then((animeCharacter) =>
          PrettyPrinter.prettyPrint(animeCharacter.toJson()));
}
