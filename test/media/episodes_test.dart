//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `episodes` resource of `episodes.json`.
Map<String, dynamic> episodeResource() =>
    (loadFixture('episodes.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/episodes/27` answers: the resource alone under `data`.
Map<String, dynamic> singleEpisodeResponse() => {'data': episodeResource()};

void main() {
  group('Episode models (episodes.json)', () {
    test('EpisodeResults keeps data, meta and links of the fixture', () {
      final results = EpisodeResults.fromJson(loadFixture('episodes.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(295051));
      expect(results.links!.first, contains('episodes'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('Episode parses the envelope of the resource', () {
      final episode =
          EpisodeResults.fromJson(loadFixture('episodes.json')).data!.first;

      expect(episode.id, equals(27));
      expect(episode.type, equals('episodes'));
      expect(episode.link, equals('https://kitsu.io/api/edge/episodes/27'));
    });

    test('EpisodeAttributes parses every attribute with its type', () {
      final attrs = EpisodeResults.fromJson(loadFixture('episodes.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.number, equals(1));
      expect(attrs.relativeNumber, equals(1));
      expect(attrs.length, equals(114));
      expect(attrs.seasonNumber, isNull);
      expect(attrs.synopsis, isNull);
      expect(attrs.description, isNull);
      expect(attrs.canonicalTitle, isNull);
      expect(attrs.airdate, isNull);
      expect(attrs.thumbnail, isNull);
      expect(attrs.titles, isEmpty);
      expect(attrs.createdAt, equals('2013-02-20T18:20:38.997Z'));
      expect(attrs.updatedAt, equals('2018-11-27T20:44:42.560Z'));
    });

    test('relationships keep the links of media and videos', () {
      final relationships =
          EpisodeResults.fromJson(loadFixture('episodes.json'))
              .data!
              .first
              .relationships!;

      expect(
        relationships.media!.links!.related,
        equals('https://kitsu.io/api/edge/episodes/27/media'),
      );
      expect(
        relationships.videos!.links!.related,
        equals('https://kitsu.io/api/edge/episodes/27/videos'),
      );
    });

    test('attributes that are missing parse as null', () {
      final episode = Episode.fromJson({
        'id': '9',
        'type': 'episodes',
        'attributes': {'number': 5},
      });

      expect(episode.attributes!.number, equals(5));
      expect(episode.attributes!.length, isNull);
      expect(episode.attributes!.canonicalTitle, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Episode.fromJson(episodeResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'createdAt': '2013-02-20T18:20:38.997Z',
          'updatedAt': '2018-11-27T20:44:42.560Z',
          'titles': <String, dynamic>{},
          'number': 1,
          'relativeNumber': 1,
          'length': 114,
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = EpisodeResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = EpisodeResults.fromJson(singleEpisodeResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.number, equals(1));
    });

    test('EpisodeResult parses a single-object response', () {
      final result = EpisodeResult.fromJson(singleEpisodeResponse());

      expect(result.data!.id, equals(27));
      expect(result.data!.attributes!.length, equals(114));
    });
  });

  group('EpisodesMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late EpisodesMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = EpisodesMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is episodes', () {
      expect(methods.methodRadix, equals('episodes'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/episodes',
        () async {
      adapter.stub('GET', '/edge/episodes',
          body: loadFixture('episodes.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/episodes'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.data!.first.attributes!.number, equals(1));
      expect(results.meta!.count, equals(295051));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/episodes', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaType: null,
        mediaId: null,
        number: null,
        seasonNumber: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/episodes', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaType: 'Anime',
        mediaId: 12,
        number: 3,
        seasonNumber: 1,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mediaType]'], equals('Anime'));
      expect(query['filter[mediaId]'], equals(12));
      expect(query['filter[number]'], equals(3));
      expect(query['filter[seasonNumber]'], equals(1));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/episodes', body: {'data': <dynamic>[]});

      await methods.fetchCollection(mediaId: 42);

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[mediaId]']));
      expect(query['filter[mediaId]'], equals(42));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/episodes', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaId: 10,
        customFilters: [Filter('special', 'true')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mediaId]'], equals(10));
      expect(query['filter[special]'], equals('true'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/episodes', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 10, offset: 20),
        sorting: Sorting('number'),
        includes: Includes(['media', 'videos']),
        sparseFieldSets: SparseFieldSets('episodes', ['canonicalTitle', 'number']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(10));
      expect(query['page[offset]'], equals(20));
      expect(query['sort'], equals('number'));
      expect(query['include'], equals('media,videos'));
      expect(query['fields[episodes]'], equals('canonicalTitle,number'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/episodes', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/episodes/<id> and parses one episode',
        () async {
      adapter.stub('GET', '/edge/episodes/27', body: singleEpisodeResponse());

      final result = await methods.fetchResource(27);

      expect(adapter.lastRequest.path, equals('/edge/episodes/27'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(27));
      expect(result.data!.attributes!.length, equals(114));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/episodes/27', body: singleEpisodeResponse());

      await methods.fetchResource(
        27,
        includes: Includes(['media']),
        sparseFieldSets: SparseFieldSets('episodes', ['number']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('media'));
      expect(query['fields[episodes]'], equals('number'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/episodes'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes episodes', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.episodes, isA<EpisodesMethods>());
      expect(kitsumon.media.episodes.methodRadix, equals('episodes'));
      expect(kitsumon.media.episodes.api, same(kitsumon.api));
    });

    test('kitsumon.media.episodes goes through the session client', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/episodes', body: loadFixture('episodes.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.episodes.fetchCollection();

      expect(results.data!.single.attributes!.number, equals(1));
    });
  });
}
