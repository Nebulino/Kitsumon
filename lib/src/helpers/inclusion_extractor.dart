//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsu.dart';

/// It extract different type of [KitsuBaseObjects] from the include variable
/// from a [Request] response.
///
/// [KitsuBaseObjects]: [KitsuBaseObject]
dynamic inclusionExtractor(dynamic inclusion) {
  // HardCoded: it's a lame implementation, but it works.
  dynamic objectFetcher(Map<String, dynamic> object) {
    switch (object['type']) {
      case 'anime':
        return Anime.fromJson(object);
      case 'animeCharacters':
      case 'characters':
        return AnimeCharacter.fromJson(object);
      default:
        // Don't do anything with the data...
        // TODO: implement all first...
        return null;
    }
  }

  if (inclusion == null) return null;

  if (inclusion is List) {
    var fetchedInclusion = <KitsuBaseObject>[];

    inclusion.forEach((dynamic object) {
      fetchedInclusion.add(objectFetcher(object));
    });
    return fetchedInclusion;
  } else if (inclusion is Map) {
    return objectFetcher(inclusion);
  } else {
    // TODO: check what happens, an exception?
    return null;
  }
}
