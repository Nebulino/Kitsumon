//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `mappings` resource of `mappings.json`.
Map<String, dynamic> mappingResource() =>
    (loadFixture('mappings.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/mappings/1` answers: the resource alone under `data`.
Map<String, dynamic> singleMappingResponse() => {'data': mappingResource()};

void main() {
  group('Mapping models (mappings.json)', () {
    test('MappingResults keeps data, meta and links of the fixture', () {
      final results = MappingResults.fromJson(loadFixture('mappings.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(341716));
      expect(results.links!.first, contains('mappings'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('Mapping parses the envelope of the resource', () {
      final mapping =
          MappingResults.fromJson(loadFixture('mappings.json')).data!.first;

      expect(mapping.id, equals(1));
      expect(mapping.type, equals('mappings'));
      expect(mapping.link, equals('https://kitsu.io/api/edge/mappings/1'));
    });

    test('MappingAttributes parses every attribute with its type', () {
      final attrs = MappingResults.fromJson(loadFixture('mappings.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.externalSite, equals('myanimelist/anime'));
      expect(attrs.externalId, equals('31608'));
      expect(attrs.createdAt, isNull);
      expect(attrs.updatedAt, isNull);
    });

    test('relationships keep the links of item', () {
      final relationships =
          MappingResults.fromJson(loadFixture('mappings.json'))
              .data!
              .first
              .relationships!;

      expect(
        relationships.item!.links!.related,
        equals('https://kitsu.io/api/edge/mappings/1/item'),
      );
    });

    test('attributes that are missing parse as null', () {
      final mapping = Mapping.fromJson({
        'id': '9',
        'type': 'mappings',
        'attributes': {'externalSite': 'anidb'},
      });

      expect(mapping.attributes!.externalSite, equals('anidb'));
      expect(mapping.attributes!.externalId, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Mapping.fromJson(mappingResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'externalSite': 'myanimelist/anime',
          'externalId': '31608',
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = MappingResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = MappingResults.fromJson(singleMappingResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.externalSite,
          equals('myanimelist/anime'));
    });

    test('MappingResult parses a single-object response', () {
      final result = MappingResult.fromJson(singleMappingResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.externalId, equals('31608'));
    });
  });

  group('MappingsMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late MappingsMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = MappingsMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is mappings', () {
      expect(methods.methodRadix, equals('mappings'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/mappings',
        () async {
      adapter.stub('GET', '/edge/mappings',
          body: loadFixture('mappings.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/mappings'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(341716));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/mappings', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        externalSite: null,
        externalId: null,
        itemId: null,
        itemType: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/mappings', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        externalSite: 'myanimelist/anime',
        externalId: '1234',
        itemId: 42,
        itemType: 'Anime',
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[externalSite]'], equals('myanimelist/anime'));
      expect(query['filter[externalId]'], equals('1234'));
      expect(query['filter[itemId]'], equals(42));
      expect(query['filter[itemType]'], equals('Anime'));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/mappings', body: {'data': <dynamic>[]});

      await methods.fetchCollection(externalSite: 'thetvdb');

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[externalSite]']));
      expect(query['filter[externalSite]'], equals('thetvdb'));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/mappings', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        externalSite: 'thetvdb',
        customFilters: [Filter('active', 'true')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[externalSite]'], equals('thetvdb'));
      expect(query['filter[active]'], equals('true'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/mappings', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 10, offset: 5),
        sorting: Sorting('externalSite'),
        includes: Includes(['item']),
        sparseFieldSets:
            SparseFieldSets('mappings', ['externalSite', 'externalId']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(10));
      expect(query['page[offset]'], equals(5));
      expect(query['sort'], equals('externalSite'));
      expect(query['include'], equals('item'));
      expect(query['fields[mappings]'], equals('externalSite,externalId'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/mappings', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/mappings/<id> and parses one mapping',
        () async {
      adapter.stub('GET', '/edge/mappings/1', body: singleMappingResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.path, equals('/edge/mappings/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.externalSite,
          equals('myanimelist/anime'));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/mappings/1', body: singleMappingResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['item']),
        sparseFieldSets: SparseFieldSets('mappings', ['externalSite']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('item'));
      expect(query['fields[mappings]'], equals('externalSite'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/mappings'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes mappings', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.mappings, isA<MappingsMethods>());
      expect(kitsumon.media.mappings.methodRadix, equals('mappings'));
      expect(kitsumon.media.mappings.api, same(kitsumon.api));
    });

    test('kitsumon.media.mappings goes through the session client', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/mappings', body: loadFixture('mappings.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.mappings.fetchCollection();

      expect(results.data!.single.attributes!.externalId, equals('31608'));
    });
  });
}
