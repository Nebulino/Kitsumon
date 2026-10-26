//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// Canned JSON:API payloads shaped like real Kitsu responses.
///
/// Every function returns a fresh object, so a test may mutate its copy.
library;

/// A single `anime` resource, as `GET /edge/anime/1` returns it.
Map<String, dynamic> animeResource() => {
      'id': '1',
      'type': 'anime',
      'links': {'self': 'https://kitsu.io/api/edge/anime/1'},
      'attributes': {
        'createdAt': '2013-02-20T16:00:13.609Z',
        'updatedAt': '2020-01-01T00:00:00.000Z',
        'slug': 'cowboy-bebop',
        'synopsis': 'In the year 2071, humanity has colonized the solar system.',
        'description':
            'In the year 2071, humanity has colonized the solar system.',
        'coverImageTopOffset': 400,
        'titles': {
          'en': 'Cowboy Bebop',
          'en_jp': 'Cowboy Bebop',
          'ja_jp': 'カウボーイビバップ',
        },
        'canonicalTitle': 'Cowboy Bebop',
        'abbreviatedTitles': ['COWBOY BEBOP'],
        'averageRating': '82.49',
        'ratingFrequencies': {'2': '83', '3': '0', '20': '4938'},
        'userCount': 43506,
        'favoritesCount': 3481,
        'startDate': '1998-04-03',
        'endDate': '1999-04-24',
        'nextRelease': null,
        'popularityRank': 10,
        'ratingRank': 25,
        'ageRating': 'R',
        'ageRatingGuide': '17+ (violence, profanity)',
        'subtype': 'TV',
        'status': 'finished',
        'tba': null,
        'episodeCount': 26,
        'episodeLength': 25,
        'totalLength': 650,
        'youtubeVideoId': 'qig4KMGW45c',
        'showType': 'TV',
        'nsfw': false,
      },
      'relationships': {
        'genres': {
          'links': {
            'self': 'https://kitsu.io/api/edge/anime/1/relationships/genres',
            'related': 'https://kitsu.io/api/edge/anime/1/genres',
          },
        },
        'animeCharacters': {
          'links': {
            'self':
                'https://kitsu.io/api/edge/anime/1/relationships/anime-characters',
            'related': 'https://kitsu.io/api/edge/anime/1/anime-characters',
          },
          'data': [
            {'type': 'animeCharacters', 'id': '101'},
            {'type': 'animeCharacters', 'id': '102'},
          ],
        },
      },
    };

/// A collection response with one anime and the pagination links and meta
/// Kitsu adds.
Map<String, dynamic> animeCollectionResponse() => {
      'data': [animeResource()],
      'meta': {'count': 1},
      'links': {
        'first': 'https://kitsu.io/api/edge/anime?page[limit]=10',
        'prev': 'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=0',
        'next':
            'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=20',
        'last':
            'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=100',
      },
    };

/// One `animeCharacters` resource, as it appears in `included`.
Map<String, dynamic> animeCharacterResource({
  String id = '101',
  String role = 'main',
  String characterId = '1',
}) =>
    {
      'id': id,
      'type': 'animeCharacters',
      'links': {'self': 'https://kitsu.io/api/edge/anime-characters/$id'},
      'attributes': {
        'createdAt': '2017-07-27T22:21:26.824Z',
        'updatedAt': '2017-07-27T22:21:26.824Z',
        'role': role,
      },
      'relationships': {
        'anime': {
          'links': {
            'self':
                'https://kitsu.io/api/edge/anime-characters/$id/relationships/anime',
            'related': 'https://kitsu.io/api/edge/anime-characters/$id/anime',
          },
          'data': {'type': 'anime', 'id': '1'},
        },
        'character': {
          'links': {
            'self':
                'https://kitsu.io/api/edge/anime-characters/$id/relationships/character',
            'related':
                'https://kitsu.io/api/edge/anime-characters/$id/character',
          },
          'data': {'type': 'characters', 'id': characterId},
        },
        'castings': {
          'links': {
            'self':
                'https://kitsu.io/api/edge/anime-characters/$id/relationships/castings',
            'related':
                'https://kitsu.io/api/edge/anime-characters/$id/castings',
          },
          'data': [
            {'type': 'castings', 'id': '5001'},
            {'type': 'castings', 'id': '5002'},
          ],
        },
      },
    };

/// A `genres` resource, as it appears in `included`. Kitsumon does not model
/// genres yet.
Map<String, dynamic> genreResource({String id = '8', String name = 'Action'}) =>
    {
      'id': id,
      'type': 'genres',
      'links': {'self': 'https://kitsu.io/api/edge/genres/$id'},
      'attributes': {'name': name, 'slug': name.toLowerCase()},
    };

/// The response of `GET /edge/anime/1?include=animeCharacters,genres`: one
/// anime plus included resources of several types.
Map<String, dynamic> animeWithIncludeResponse() => {
      'data': animeResource(),
      'included': [
        animeCharacterResource(id: '101', role: 'main', characterId: '1'),
        genreResource(),
        animeCharacterResource(
            id: '102', role: 'supporting', characterId: '2'),
      ],
    };
