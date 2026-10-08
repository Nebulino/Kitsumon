//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  final sampleAnimeJson = {
    'id': '1',
    'type': 'anime',
    'links': {
      'self': 'https://kitsu.io/api/edge/anime/1',
    },
    'attributes': {
      'createdAt': '2013-02-20T16:00:13.609Z',
      'updatedAt': '2020-01-01T00:00:00.000Z',
      'slug': 'cowboy-bebop',
      'synopsis': 'In the year 2071, humanity has colonized the solar system...',
      'description': 'In the year 2071, humanity has colonized the solar system...',
      'coverImageTopOffset': 400,
      'titles': {
        'en': 'Cowboy Bebop',
        'en_jp': 'Cowboy Bebop',
        'ja_jp': 'カウボーイビバップ',
      },
      'canonicalTitle': 'Cowboy Bebop',
      'abbreviatedTitles': ['COWBOY BEBOP'],
      'averageRating': '82.49',
      'ratingFrequencies': {
        '2': '83',
        '3': '0',
        '20': '4938',
      },
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
      'posterImage': {
        'tiny': 'https://media.kitsu.io/anime/poster_images/1/tiny.jpg',
        'small': 'https://media.kitsu.io/anime/poster_images/1/small.jpg',
        'medium': 'https://media.kitsu.io/anime/poster_images/1/medium.jpg',
        'large': 'https://media.kitsu.io/anime/poster_images/1/large.jpg',
        'original': 'https://media.kitsu.io/anime/poster_images/1/original.jpg',
        'meta': {
          'dimensions': {
            'tiny': {'width': 110, 'height': 156},
            'small': {'width': 284, 'height': 402},
            'medium': {'width': 390, 'height': 554},
            'large': {'width': 550, 'height': 780},
          },
        },
      },
      'coverImage': {
        'tiny': 'https://media.kitsu.io/anime/cover_images/1/tiny.jpg',
        'small': 'https://media.kitsu.io/anime/cover_images/1/small.jpg',
        'large': 'https://media.kitsu.io/anime/cover_images/1/large.jpg',
        'original': 'https://media.kitsu.io/anime/cover_images/1/original.jpg',
        'meta': {
          'dimensions': {
            'tiny': {'width': 840, 'height': 200},
            'small': {'width': 1680, 'height': 400},
            'large': {'width': 3360, 'height': 800},
          },
        },
      },
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
    },
  };

  final sampleSingleAnimeResponse = {
    'data': sampleAnimeJson,
  };

  final sampleCollectionResponse = {
    'data': [sampleAnimeJson],
    'meta': {'count': 1},
    'links': {
      'first': 'https://kitsu.io/api/edge/anime?page[limit]=10',
      'prev': 'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=0',
      'next': 'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=20',
      'last': 'https://kitsu.io/api/edge/anime?page[limit]=10&page[offset]=100',
    },
  };

  group('Anime Model Deserialization & Serialization', () {
    test('deserializes single anime response correctly', () {
      final result = AnimeResult.fromJson(sampleSingleAnimeResponse);
      final anime = result.data;

      expect(anime, isNotNull);
      expect(anime!.id, equals(1));
      expect(anime.type, equals('anime'));
      expect(anime.link, equals('https://kitsu.io/api/edge/anime/1'));

      final attrs = anime.attributes;
      expect(attrs, isNotNull);
      expect(attrs!.slug, equals('cowboy-bebop'));
      expect(attrs.canonicalTitle, equals('Cowboy Bebop'));
      expect(attrs.title?.en, equals('Cowboy Bebop'));
      expect(attrs.title?.jaJp, equals('カウボーイビバップ'));
      expect(attrs.abbreviatedTitles, contains('COWBOY BEBOP'));
      expect(attrs.averageRating, equals('82.49'));
      expect(attrs.ratingFrequencies?.$20, equals('4938'));
      // ignore: deprecated_member_use_from_same_package
      expect(attrs.ratingsFrequencies?.$20, equals('4938'));
      expect(attrs.userCount, equals(43506));
      expect(attrs.favoritesCount, equals(3481));
      expect(attrs.startDate, equals('1998-04-03'));
      expect(attrs.endDate, equals('1999-04-24'));
      expect(attrs.popularityRank, equals(10));
      expect(attrs.ratingRank, equals(25));
      expect(attrs.ageRating, equals(AgeRating.R));
      expect(attrs.ageRating?.rate, equals('R'));
      expect(attrs.ageRatingGuide, equals('17+ (violence, profanity)'));
      expect(attrs.subtype, equals(AnimeSubtype.TV));
      expect(attrs.subtype?.type, equals('TV'));
      expect(attrs.status, equals(AnimeStatus.finished));
      expect(attrs.status?.status, equals('finished'));
      expect(attrs.episodeCount, equals(26));
      expect(attrs.episodeLength, equals(25));
      expect(attrs.totalLength, equals(650));
      expect(attrs.coverImageTopOffset, equals(400));
      expect(attrs.youtubeVideoId, equals('qig4KMGW45c'));
      expect(attrs.showType, equals('TV'));
      expect(attrs.nsfw, isFalse);

      expect(attrs.posterImage?.large, contains('large.jpg'));
      expect(attrs.posterImage?.meta?.dimensions?.large?.width, equals(550));
      expect(attrs.coverImage?.original, contains('original.jpg'));

      final json = result.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['data'], isNotNull);
    });

    test('deserializes anime collection response with pagination links and meta', () {
      final results = AnimeResults.fromJson(sampleCollectionResponse);

      expect(results.data, isNotNull);
      expect(results.data!.length, equals(1));
      expect(results.data!.first.attributes?.slug, equals('cowboy-bebop'));

      expect(results.meta?.count, equals(1));
      expect(results.links?.first, contains('page[limit]=10'));
      expect(results.links?.prev, contains('offset]=0'));
      expect(results.links?.next, contains('offset]=20'));
      expect(results.links?.last, contains('offset]=100'));
    });
  });

  group('AnimeMethods Request Generation & Response Handling', () {
    late RequestOptions lastRequest;

    Kitsu createMockKitsu(Map<String, dynamic> responseData) {
      final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastRequest = options;
            handler.resolve(
              Response(
                requestOptions: options,
                data: responseData,
                statusCode: 200,
              ),
            );
          },
        ),
      );
      return Kitsu.withClient(KitsuClient(dio: dio));
    }

    test('fetchCollection sends correct default request', () async {
      final kitsu = createMockKitsu(sampleCollectionResponse);
      final methods = AnimeMethods(kitsu);

      final results = await methods.fetchCollection();

      expect(lastRequest.path, equals('/edge/anime'));
      expect(lastRequest.queryParameters, isEmpty);
      expect(results.data?.length, equals(1));
    });

    test('fetchCollection serializes all typed filters and options correctly', () async {
      final kitsu = createMockKitsu(sampleCollectionResponse);
      final methods = AnimeMethods(kitsu);

      await methods.fetchCollection(
        text: 'Cowboy',
        season: 'spring',
        seasonYear: 1998,
        subtypes: [AnimeSubtype.TV, AnimeSubtype.movie],
        status: [AnimeStatus.finished, AnimeStatus.current],
        ageRatings: [AgeRating.PG, AgeRating.R],
        categories: ['adventure', 'space'],
        genres: ['action', 'sci-fi'],
        ids: [1, 2],
        slug: 'cowboy-bebop',
        customFilters: [Filter('streamers', 'crunchyroll')],
        pagination: Pagination(limit: 15, offset: 30),
        sorting: Sorting.multiple(['-userCount', 'canonicalTitle']),
        includes: Includes(['genres', 'categories']),
        sparseFieldSets: SparseFieldSets('anime', ['slug', 'canonicalTitle']),
      );

      final params = lastRequest.queryParameters;
      expect(params['filter[text]'], equals('Cowboy'));
      expect(params['filter[season]'], equals('spring'));
      expect(params['filter[seasonYear]'], equals(1998));
      expect(params['filter[subtype]'], equals('TV,movie'));
      expect(params['filter[status]'], equals('finished,current'));
      expect(params['filter[ageRating]'], equals('PG,R'));
      expect(params['filter[categories]'], equals('adventure,space'));
      expect(params['filter[genres]'], equals('action,sci-fi'));
      expect(params['filter[id]'], equals('1,2'));
      expect(params['filter[slug]'], equals('cowboy-bebop'));
      expect(params['filter[streamers]'], equals('crunchyroll'));
      expect(params['page[limit]'], equals(15));
      expect(params['page[offset]'], equals(30));
      expect(params['sort'], equals('-userCount,canonicalTitle'));
      expect(params['include'], equals('genres,categories'));
      expect(params['fields[anime]'], equals('slug,canonicalTitle'));
    });

    test('fetchResource requests single anime by ID with includes & sparse fieldsets', () async {
      final kitsu = createMockKitsu(sampleSingleAnimeResponse);
      final methods = AnimeMethods(kitsu);

      final result = await methods.fetchResource(
        1,
        includes: Includes(['genres']),
        sparseFieldSets: SparseFieldSets('anime', ['slug']),
      );

      expect(lastRequest.path, equals('/edge/anime/1'));
      expect(lastRequest.queryParameters['include'], equals('genres'));
      expect(lastRequest.queryParameters['fields[anime]'], equals('slug'));
      expect(result.data?.id, equals(1));
    });

    test('fetchBySlug returns Anime when found', () async {
      final kitsu = createMockKitsu(sampleCollectionResponse);
      final methods = AnimeMethods(kitsu);

      final anime = await methods.fetchBySlug('cowboy-bebop');

      expect(lastRequest.path, equals('/edge/anime'));
      expect(lastRequest.queryParameters['filter[slug]'], equals('cowboy-bebop'));
      expect(lastRequest.queryParameters['page[limit]'], equals(1));
      expect(anime, isNotNull);
      expect(anime?.attributes?.slug, equals('cowboy-bebop'));
    });

    test('fetchBySlug returns null when collection is empty', () async {
      final kitsu = createMockKitsu({'data': <dynamic>[]});
      final methods = AnimeMethods(kitsu);

      final anime = await methods.fetchBySlug('non-existent');

      expect(anime, isNull);
    });

    test('fetchTrending calls /edge/trending/anime with options', () async {
      final kitsu = createMockKitsu(sampleCollectionResponse);
      final methods = AnimeMethods(kitsu);

      final results = await methods.fetchTrending(
        pagination: Pagination(limit: 5),
        includes: Includes(['genres']),
      );

      expect(lastRequest.path, equals('/edge/trending/anime'));
      expect(lastRequest.queryParameters['page[limit]'], equals(5));
      expect(lastRequest.queryParameters['include'], equals('genres'));
      expect(results.data?.length, equals(1));
    });
  });

  group('Kitsumon Aggregator Wiring', () {
    test('Kitsumon initializes and exposes media.anime and components', () {
      final kitsu = Kitsu.noAuth();
      final kitsumon = Kitsumon(kitsu: kitsu);

      expect(kitsumon.api, equals(kitsu));
      expect(kitsumon.media, isNotNull);
      expect(kitsumon.media.anime, isNotNull);
      expect(kitsumon.media.anime, isA<AnimeMethods>());
      expect(kitsumon.charactersAndPeople.animeCharacters, isNotNull);
      expect(Kitsumon.instance, equals(kitsumon));
    });
  });
}
