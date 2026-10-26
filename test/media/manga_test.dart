//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The `manga` resource of `manga_1.json`, to be wrapped as needed.
Map<String, dynamic> mangaResource() =>
    loadFixture('manga_1.json')['data'] as Map<String, dynamic>;

/// A collection response holding [resources] (no `meta`, as the trending
/// endpoint answers).
Map<String, dynamic> collectionOf(List<Map<String, dynamic>> resources) =>
    {'data': resources};

void main() {
  group('Manga models (manga_1.json)', () {
    test('MangaResult parses the resource envelope', () {
      final result = MangaResult.fromJson(loadFixture('manga_1.json'));
      final manga = result.data;

      expect(manga, isNotNull);
      expect(manga!.id, equals(1));
      expect(manga.type, equals('manga'));
      expect(manga.link, equals('https://kitsu.io/api/edge/manga/1'));
    });

    test('MangaAttributes parses the attributes of the fixture', () {
      final attrs =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!;

      expect(attrs.slug, equals('guardian-dog'));
      expect(attrs.canonicalTitle, equals('Guardian Dog'));
      expect(attrs.abbreviatedTitles, equals(['Guardian Dog']));
      expect(attrs.subtype, equals(MangaSubtype.manga));
      expect(attrs.status, equals(MangaStatus.finished));
      expect(attrs.mangaType, equals('manga'));
      expect(attrs.serialization, equals('Comic Rush'));
      expect(attrs.chapterCount, equals(22));
      expect(attrs.volumeCount, equals(4));
      expect(attrs.coverImageTopOffset, equals(0));
      expect(attrs.userCount, equals(215));
      expect(attrs.favoritesCount, equals(2));
      expect(attrs.popularityRank, equals(10658));
      expect(attrs.ratingRank, equals(7764));
      expect(attrs.startDate, equals('2005-01-01'));
      expect(attrs.endDate, equals('2005-12-31'));
      expect(attrs.createdAt, equals('2013-12-18T13:48:24.164Z'));
      expect(attrs.updatedAt, equals('2026-10-26T12:00:26.150Z'));
      expect(attrs.synopsis, startsWith('Gengo Kurosaka leads a normal life'));
      expect(attrs.description, equals(attrs.synopsis));
    });

    test('averageRating stays the string the API sends', () {
      final attrs =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!;

      expect(attrs.averageRating, isA<String>());
      expect(attrs.averageRating, equals('71.36'));
    });

    test('null members of the fixture parse as null', () {
      final attrs =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!;

      expect(attrs.nextRelease, isNull);
      expect(attrs.tba, isNull);
      expect(attrs.ageRating, isNull);
      expect(attrs.ageRatingGuide, isNull);
      expect(attrs.coverImage, isNull);
    });

    test('nullable counts and dates parse as null', () {
      final resource = mangaResource();
      (resource['attributes'] as Map<String, dynamic>)
        ..['chapterCount'] = null
        ..['volumeCount'] = null
        ..['startDate'] = null
        ..['endDate'] = null;

      final attrs = Manga.fromJson(resource).attributes!;

      expect(attrs.chapterCount, isNull);
      expect(attrs.volumeCount, isNull);
      expect(attrs.startDate, isNull);
      expect(attrs.endDate, isNull);
    });

    test('a nextRelease date is kept as sent', () {
      final resource = mangaResource();
      (resource['attributes'] as Map<String, dynamic>)['nextRelease'] =
          '2026-12-01';

      expect(Manga.fromJson(resource).attributes!.nextRelease,
          equals('2026-12-01'));
    });

    test('titles use the locales the manga fixture has', () {
      final titles =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!.titles!;

      expect(titles.japaneseRomaji, equals('Guardian Dog'));
      expect(titles.enJp, equals('Guardian Dog'));
      expect(titles.americanEnglish, equals('Guardian Dog'));
      expect(titles.enUs, equals('Guardian Dog'));
      expect(titles.english, isNull);
      expect(titles.japanese, isNull);
    });

    test('titles serialize back to the same keys', () {
      final titles =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!.titles!;

      expect(titles.toJson(),
          equals({'en_jp': 'Guardian Dog', 'en_us': 'Guardian Dog'}));
    });

    test('the other locales a manga can have are read', () {
      final titles = MangaTitle.fromJson({
        'en': 'Berserk',
        'ja_jp': 'ベルセルク',
        'ko_kr': '베르세르크',
        'zh_cn': '剑风传奇',
      });

      expect(titles.en, equals('Berserk'));
      expect(titles.jaJp, equals('ベルセルク'));
      expect(titles.koKr, equals('베르세르크'));
      expect(titles.zhCn, equals('剑风传奇'));
    });

    test('rating frequencies and images reuse the shared classes', () {
      final attrs =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.attributes!;

      expect(attrs.ratingFrequencies, isA<RatingFrequencies>());
      expect(attrs.ratingFrequencies!.$2, equals('1'));
      expect(attrs.ratingFrequencies!.$12, equals('29'));
      expect(attrs.ratingFrequencies!.$20, equals('6'));

      final poster = attrs.posterImage!;
      expect(poster, isA<PosterImage>());
      expect(poster.original,
          equals('https://media.kitsu.app/manga/poster_images/1/original.jpg'));
      expect(poster.meta!.dimensions!.large!.width, equals(550));
      expect(poster.meta!.dimensions!.large!.height, equals(780));
    });

    test('relationships keep the links of every relation', () {
      final relationships =
          MangaResult.fromJson(loadFixture('manga_1.json')).data!.relationships!;

      expect(relationships.genres!.links!.related,
          equals('https://kitsu.io/api/edge/manga/1/genres'));
      expect(relationships.genres!.links!.self,
          equals('https://kitsu.io/api/edge/manga/1/relationships/genres'));
      expect(relationships.mangaStaff!.links!.related,
          equals('https://kitsu.io/api/edge/manga/1/manga-staff'));

      final all = [
        relationships.genres,
        relationships.categories,
        relationships.castings,
        relationships.installments,
        relationships.mappings,
        relationships.reviews,
        relationships.mediaRelationships,
        relationships.characters,
        relationships.staff,
        relationships.productions,
        relationships.quotes,
        relationships.chapters,
        relationships.mangaCharacters,
        relationships.mangaStaff,
      ];
      expect(all, everyElement(isNotNull));
      expect(all.length, equals(14));
    });

    test('a relation keeps its linkage when the API sends one', () {
      final relation = KitsuRelation.fromJson({
        'links': {'related': 'https://kitsu.io/api/edge/manga/1/genres'},
        'data': [
          {'type': 'genres', 'id': '8'},
        ],
      });

      expect(relation.data, isA<List>());
      expect((relation.data as List).single['id'], equals('8'));
    });

    test('the manga serializes back to the attributes of the fixture', () {
      final manga = MangaResult.fromJson(loadFixture('manga_1.json')).data!;
      final attributes = manga.attributes!.toJson();

      expect(attributes['slug'], equals('guardian-dog'));
      expect(attributes['subtype'], equals('manga'));
      expect(attributes['status'], equals('finished'));
      expect(attributes['chapterCount'], equals(22));
      expect(attributes['averageRating'], equals('71.36'));
      expect((attributes['titles'] as MangaTitle).toJson(),
          equals({'en_jp': 'Guardian Dog', 'en_us': 'Guardian Dog'}));
      expect(attributes.containsKey('coverImage'), isFalse);
    });
  });

  group('Manga enums', () {
    test('every subtype the API uses is parsed and sent back verbatim', () {
      const subtypes = {
        'manga': MangaSubtype.manga,
        'novel': MangaSubtype.novel,
        'one_shot': MangaSubtype.oneShot,
        'doujin': MangaSubtype.doujin,
        'manhua': MangaSubtype.manhua,
        'oel': MangaSubtype.oel,
        'manhwa': MangaSubtype.manhwa,
      };
      expect(MangaSubtype.values.length, equals(subtypes.length));

      for (final entry in subtypes.entries) {
        final resource = mangaResource();
        (resource['attributes'] as Map<String, dynamic>)['subtype'] = entry.key;

        final manga = Manga.fromJson(resource);

        expect(manga.attributes!.subtype, equals(entry.value),
            reason: entry.key);
        expect(entry.value.type, equals(entry.key));
        expect(manga.attributes!.toJson()['subtype'], equals(entry.key));
      }
    });

    test('every status the API uses is parsed and sent back verbatim', () {
      const statuses = {
        'current': MangaStatus.current,
        'finished': MangaStatus.finished,
        'tba': MangaStatus.tba,
        'unreleased': MangaStatus.unreleased,
        'upcoming': MangaStatus.upcoming,
      };
      expect(MangaStatus.values.length, equals(statuses.length));

      for (final entry in statuses.entries) {
        final resource = mangaResource();
        (resource['attributes'] as Map<String, dynamic>)['status'] = entry.key;

        final manga = Manga.fromJson(resource);

        expect(manga.attributes!.status, equals(entry.value),
            reason: entry.key);
        expect(entry.value.status, equals(entry.key));
      }
    });

    test('an enum value the package does not know parses as null', () {
      final resource = mangaResource();
      (resource['attributes'] as Map<String, dynamic>)
        ..['subtype'] = 'webtoon'
        ..['status'] = 'hiatus';

      final attrs = Manga.fromJson(resource).attributes!;

      expect(attrs.subtype, isNull);
      expect(attrs.status, isNull);
    });

    test('an age rating is parsed with the shared AgeRating enum', () {
      final resource = mangaResource();
      (resource['attributes'] as Map<String, dynamic>)['ageRating'] = 'R18';

      expect(Manga.fromJson(resource).attributes!.ageRating,
          equals(AgeRating.R18));
    });
  });

  group('MangaResults', () {
    test('a collection response keeps data, meta and links', () {
      final results = MangaResults.fromJson({
        'data': [mangaResource(), mangaResource()],
        'meta': {'count': 2},
        'links': {
          'first': 'https://kitsu.io/api/edge/manga?page[limit]=2',
          'next': 'https://kitsu.io/api/edge/manga?page[offset]=2',
        },
      });

      expect(results.data, hasLength(2));
      expect(results.data!.first.attributes!.slug, equals('guardian-dog'));
      expect(results.meta!.count, equals(2));
      expect(results.links!.first, contains('page[limit]=2'));
      expect(results.links!.next, contains('page[offset]=2'));
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = MangaResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isNotNull);
      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a response without meta parses with a null meta', () {
      final results = MangaResults.fromJson(collectionOf([mangaResource()]));

      expect(results.data, hasLength(1));
      expect(results.meta, isNull);
      expect(results.links, isNull);
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = MangaResults.fromJson(loadFixture('manga_1.json'));

      expect(results.data, hasLength(1));
      expect(results.data!.single.id, equals(1));
      expect(results.data!.single.attributes!.slug, equals('guardian-dog'));
    });
  });

  group('MangaMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late MangaMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = MangaMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is manga', () {
      expect(methods.methodRadix, equals('manga'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/manga',
        () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([mangaResource()]));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/manga'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.canonicalTitle,
          equals('Guardian Dog'));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([]));

      await methods.fetchCollection(
        text: null,
        subtypes: null,
        status: null,
        categories: null,
        genres: null,
        ids: null,
        slug: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(adapter.lastRequest.uri.query, isEmpty);

      await methods.fetchCollection(
        text: '',
        subtypes: const [],
        status: const [],
        categories: const [],
        genres: const [],
        ids: const [],
        slug: '',
        customFilters: const [],
      );
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([mangaResource()]));

      await methods.fetchCollection(
        text: 'guardian',
        subtypes: [MangaSubtype.manga, MangaSubtype.oneShot],
        status: [MangaStatus.current, MangaStatus.finished],
        categories: ['action', 'drama'],
        genres: ['comedy', 'horror'],
        ids: [1, 2, 3],
        slug: 'guardian-dog',
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'filter[text]': 'guardian',
          'filter[subtype]': 'manga,one_shot',
          'filter[status]': 'current,finished',
          'filter[categories]': 'action,drama',
          'filter[genres]': 'comedy,horror',
          'filter[id]': '1,2,3',
          'filter[slug]': 'guardian-dog',
        }),
      );
      expect(adapter.lastRequest.queryParameters,
          isNot(contains('filter[seasonYear]')));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([]));

      await methods.fetchCollection(text: 'berserk', status: [MangaStatus.tba]);

      expect(
        adapter.lastRequest.queryParameters,
        equals({'filter[text]': 'berserk', 'filter[status]': 'tba'}),
      );
    });

    test('fetchCollection forwards custom filters next to the typed ones',
        () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([]));

      await methods.fetchCollection(
        text: 'berserk',
        customFilters: [
          Filter('serialization', 'Young Animal'),
          Filter('chapterCount', null),
        ],
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'filter[text]': 'berserk',
          'filter[serialization]': 'Young Animal',
        }),
      );
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([]));

      await methods.fetchCollection(
        sorting: Sorting('popularityRank', descending: true),
        pagination: Pagination(limit: 5, offset: 10),
        includes: Includes(['genres', 'categories']),
        sparseFieldSets: SparseFieldSets('manga', ['slug', 'canonicalTitle']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'sort': '-popularityRank',
          'page[limit]': 5,
          'page[offset]': 10,
          'include': 'genres,categories',
          'fields[manga]': 'slug,canonicalTitle',
        }),
      );
    });

    test('fetchCollection sends only the pagination keys that are set',
        () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([]));

      await methods.fetchCollection(pagination: Pagination(limit: 3));

      expect(adapter.lastRequest.queryParameters, equals({'page[limit]': 3}));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/manga',
          body: {'data': <dynamic>[], 'meta': {'count': 0}});

      final results = await methods.fetchCollection(text: 'nothing-matches');

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/manga/<id> and parses one manga',
        () async {
      adapter.stub('GET', '/edge/manga/1', body: loadFixture('manga_1.json'));

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/manga/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.slug, equals('guardian-dog'));
      expect(result.data!.attributes!.chapterCount, equals(22));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/manga/1', body: loadFixture('manga_1.json'));

      await methods.fetchResource(
        1,
        includes: Includes(['genres']),
        sparseFieldSets: SparseFieldSets('manga', ['slug']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({'include': 'genres', 'fields[manga]': 'slug'}),
      );
    });

    test('a single-object response also reads as a collection of one',
        () async {
      adapter.stub('GET', '/edge/manga', body: loadFixture('manga_1.json'));

      final results = await methods.fetchCollection(slug: 'guardian-dog');

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.slug, equals('guardian-dog'));
    });

    test('fetchBySlug filters by slug, asks for one and returns the manga',
        () async {
      adapter.stub('GET', '/edge/manga', body: collectionOf([mangaResource()]));

      final manga = await methods.fetchBySlug('guardian-dog');

      expect(adapter.lastRequest.path, equals('/edge/manga'));
      expect(
        adapter.lastRequest.queryParameters,
        equals({'filter[slug]': 'guardian-dog', 'page[limit]': 1}),
      );
      expect(manga, isNotNull);
      expect(manga!.attributes!.slug, equals('guardian-dog'));
    });

    test('fetchBySlug returns null when nothing matches', () async {
      adapter.stub('GET', '/edge/manga', body: {'data': <dynamic>[]});

      expect(await methods.fetchBySlug('does-not-exist'), isNull);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/manga'));
    });
  });

  group('TrendingMangaMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late TrendingMangaMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = TrendingMangaMethods(createFakeKitsu(adapter));
    });

    test('fetchTrending hits /edge/trending/manga with no parameters',
        () async {
      adapter.stub('GET', '/edge/trending/manga',
          body: collectionOf([mangaResource()]));

      final trending = await methods.fetchTrending();

      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/trending/manga'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(trending, isA<List<Manga>>());
      expect(trending, hasLength(1));
      expect(trending.single.attributes!.slug, equals('guardian-dog'));
    });

    test('fetchTrending handles an answer without a meta block', () async {
      final body = collectionOf([mangaResource(), mangaResource()]);
      expect(body.containsKey('meta'), isFalse);
      adapter.stub('GET', '/edge/trending/manga', body: body);

      final trending = await methods.fetchTrending();

      expect(trending, hasLength(2));
    });

    test('fetchTrending returns an empty list for data: []', () async {
      adapter.stub('GET', '/edge/trending/manga', body: {'data': <dynamic>[]});

      expect(await methods.fetchTrending(), isEmpty);
    });

    test('fetchTrending sends pagination, include and fields only if given',
        () async {
      adapter.stub('GET', '/edge/trending/manga', body: collectionOf([]));

      await methods.fetchTrending(
        pagination: Pagination(limit: 5),
        includes: Includes(['genres']),
        sparseFieldSets: SparseFieldSets('manga', ['slug']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'page[limit]': 5,
          'include': 'genres',
          'fields[manga]': 'slug',
        }),
      );
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes manga and trendingManga', () {
      final adapter = FakeHttpClientAdapter();
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      expect(kitsumon.media.manga, isA<MangaMethods>());
      expect(kitsumon.media.manga.methodRadix, equals('manga'));
      expect(kitsumon.media.trendingManga, isA<TrendingMangaMethods>());
      expect(kitsumon.media.trendingManga.methodRadix,
          equals('trending/manga'));
      expect(kitsumon.media.manga.api, same(kitsumon.api));
      expect(kitsumon.media.trendingManga.api, same(kitsumon.api));
    });

    test('kitsumon.media.manga goes through the session client', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/manga/1', body: loadFixture('manga_1.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final result = await kitsumon.media.manga.fetchResource(1);

      expect(result.data!.attributes!.slug, equals('guardian-dog'));
    });
  });
}
