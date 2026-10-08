//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';

// Just an example of use.
void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  print('animeCharacters.fetchCollection()');

  final collection =
      await kitsumon.charactersAndPeople.animeCharacters.fetchCollection(
    animeID: [
      11614,
      42028,
    ],
  );
  print(collection.data?[0].attributes?.role);

  print('animeCharacters.fetchResource()');
  final resource =
      await kitsumon.charactersAndPeople.animeCharacters.fetchResource(
    11614,
    includes: Includes(['anime']),
    sparseFieldSets: SparseFieldSets('anime', ['createdAt']),
  );
  print(resource.data?.attributes?.role);
}
