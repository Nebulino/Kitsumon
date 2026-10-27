//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `characters` resource of `characters.json`.
Map<String, dynamic> characterResource() =>
    (loadFixture('characters.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/characters/1` answers: the resource alone under `data`.
Map<String, dynamic> singleCharacterResponse() =>
    {'data': characterResource()};

void main() {
  group('Character models (characters.json)', () {
    test('CharacterResults keeps data, meta and links of the fixture', () {
      final results =
          CharacterResults.fromJson(loadFixture('characters.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(105906));
      expect(results.links!.first, contains('characters'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('Character parses the envelope of the resource', () {
      final character = CharacterResults.fromJson(
              loadFixture('characters.json'))
          .data!
          .first;

      expect(character.id, equals(1));
      expect(character.type, equals('characters'));
      expect(character.link, equals('https://kitsu.io/api/edge/characters/1'));
    });

    test('CharacterAttributes parses every attribute with its type', () {
      final attrs = CharacterResults.fromJson(
              loadFixture('characters.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.slug, equals('jet-black'));
      expect(attrs.name, equals('Jet Black'));
      expect(attrs.canonicalName, equals('Jet Black'));
      expect(attrs.names, equals({'en': 'Jet Black', 'ja_jp': 'ジェット・ブラック'}));
      expect(attrs.otherNames, equals(['Running Rock', 'Black Dog']));
      expect(attrs.malId, equals(3));
      expect(attrs.description, contains('Jet, known on his home satellite'));
      expect(attrs.image, isNotNull);
      expect(attrs.image!['tiny'], contains('tiny-'));
      expect(attrs.createdAt, equals('2013-02-20T18:49:20.901Z'));
      expect(attrs.updatedAt, equals('2021-09-25T06:59:59.531Z'));
    });

    test('relationships keep the links of primaryMedia, castings, mediaCharacters and quotes', () {
      final relationships = CharacterResults.fromJson(
              loadFixture('characters.json'))
          .data!
          .first
          .relationships!;

      expect(
        relationships.primaryMedia!.links!.related,
        equals('https://kitsu.io/api/edge/characters/1/primary-media'),
      );
      expect(
        relationships.castings!.links!.related,
        equals('https://kitsu.io/api/edge/characters/1/castings'),
      );
      expect(
        relationships.mediaCharacters!.links!.related,
        equals('https://kitsu.io/api/edge/characters/1/media-characters'),
      );
      expect(
        relationships.quotes!.links!.related,
        equals('https://kitsu.io/api/edge/characters/1/quotes'),
      );
    });

    test('attributes that are missing parse as null', () {
      final character = Character.fromJson({
        'id': '9',
        'type': 'characters',
        'attributes': {'name': 'Faye Valentine'},
      });

      expect(character.attributes!.name, equals('Faye Valentine'));
      expect(character.attributes!.slug, isNull);
      expect(character.attributes!.malId, isNull);
      expect(character.attributes!.otherNames, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Character.fromJson(characterResource()).attributes!;
      final json = attrs.toJson();

      expect(json['slug'], equals('jet-black'));
      expect(json['name'], equals('Jet Black'));
      expect(json['canonicalName'], equals('Jet Black'));
      expect(json['malId'], equals(3));
      expect(json['names'], equals({'en': 'Jet Black', 'ja_jp': 'ジェット・ブラック'}));
      expect(json['otherNames'], equals(['Running Rock', 'Black Dog']));
      expect(json['createdAt'], equals('2013-02-20T18:49:20.901Z'));
      expect(json['updatedAt'], equals('2021-09-25T06:59:59.531Z'));
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = CharacterResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = CharacterResults.fromJson(singleCharacterResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.name, equals('Jet Black'));
    });

    test('CharacterResult parses a single-object response', () {
      final result = CharacterResult.fromJson(singleCharacterResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.slug, equals('jet-black'));
    });
  });

  group('CharactersMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late CharactersMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = CharactersMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is characters', () {
      expect(methods.methodRadix, equals('characters'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/characters',
        () async {
      adapter.stub('GET', '/edge/characters',
          body: loadFixture('characters.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/characters'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(105906));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: null,
        slug: null,
        malId: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: 'Jet Black',
        slug: 'jet-black',
        malId: 3,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[name]'], equals('Jet Black'));
      expect(query['filter[slug]'], equals('jet-black'));
      expect(query['filter[malId]'], equals(3));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(slug: 'spike-spiegel');

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[slug]']));
      expect(query['filter[slug]'], equals('spike-spiegel'));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        slug: 'spike-spiegel',
        customFilters: [Filter('active', 'true')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[slug]'], equals('spike-spiegel'));
      expect(query['filter[active]'], equals('true'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 10, offset: 5),
        sorting: Sorting('name'),
        includes: Includes(['primaryMedia', 'castings']),
        sparseFieldSets:
            SparseFieldSets('characters', ['name', 'slug']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(10));
      expect(query['page[offset]'], equals(5));
      expect(query['sort'], equals('name'));
      expect(query['include'], equals('primaryMedia,castings'));
      expect(query['fields[characters]'], equals('name,slug'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/characters', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/characters/<id> and parses one character',
        () async {
      adapter.stub('GET', '/edge/characters/1', body: singleCharacterResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.path, equals('/edge/characters/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.name, equals('Jet Black'));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/characters/1', body: singleCharacterResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['primaryMedia']),
        sparseFieldSets: SparseFieldSets('characters', ['name']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('primaryMedia'));
      expect(query['fields[characters]'], equals('name'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('fetchBySlug filters by slug, asks for one and returns the character',
        () async {
      adapter.stub('GET', '/edge/characters', body: singleCharacterResponse());

      final character = await methods.fetchBySlug('jet-black');

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[slug]'], equals('jet-black'));
      expect(query['page[limit]'], equals(1));
      expect(character, isNotNull);
      expect(character!.attributes!.name, equals('Jet Black'));
    });

    test('fetchBySlug returns null when nothing matches', () async {
      adapter.stub('GET', '/edge/characters', body: {'data': <dynamic>[]});

      expect(await methods.fetchBySlug('does-not-exist'), isNull);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/characters'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('charactersAndPeople exposes characters', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.charactersAndPeople.characters, isA<CharactersMethods>());
      expect(kitsumon.charactersAndPeople.characters.methodRadix,
          equals('characters'));
      expect(kitsumon.charactersAndPeople.characters.api, same(kitsumon.api));
    });

    test('kitsumon.charactersAndPeople.characters goes through the session client',
        () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/characters', body: loadFixture('characters.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results =
          await kitsumon.charactersAndPeople.characters.fetchCollection();

      expect(results.data!.single.attributes!.name, equals('Jet Black'));
    });
  });
}
