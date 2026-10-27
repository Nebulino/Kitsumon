//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `people` resource of `people.json`.
Map<String, dynamic> personResource() =>
    (loadFixture('people.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/people/1` answers: the resource alone under `data`.
Map<String, dynamic> singlePersonResponse() => {'data': personResource()};

void main() {
  group('Person models (people.json)', () {
    test('PersonResults keeps data, meta and links of the fixture', () {
      final results = PersonResults.fromJson(loadFixture('people.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(35338));
      expect(results.links!.first, contains('people'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('Person parses the envelope of the resource', () {
      final person =
          PersonResults.fromJson(loadFixture('people.json')).data!.first;

      expect(person.id, equals(1));
      expect(person.type, equals('people'));
      expect(person.link, equals('https://kitsu.io/api/edge/people/1'));
    });

    test('PersonAttributes parses every attribute with its type', () {
      final attrs = PersonResults.fromJson(loadFixture('people.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.name, equals('Masahiko Minami'));
      expect(attrs.malId, equals('Moved to mappings relationship.'));
      expect(attrs.description, equals(' Wikipedia'));
      expect(attrs.image, isNotNull);
      expect(attrs.image!['original'], contains('original.jpg'));
      expect(attrs.createdAt, equals('2013-02-20T18:49:20.441Z'));
      expect(attrs.updatedAt, equals('2021-09-16T22:51:01.875Z'));
    });

    test('relationships keep the links of castings, staff and voices', () {
      final relationships =
          PersonResults.fromJson(loadFixture('people.json'))
              .data!
              .first
              .relationships!;

      expect(
        relationships.castings!.links!.related,
        equals('https://kitsu.io/api/edge/people/1/castings'),
      );
      expect(
        relationships.staff!.links!.related,
        equals('https://kitsu.io/api/edge/people/1/staff'),
      );
      expect(
        relationships.voices!.links!.related,
        equals('https://kitsu.io/api/edge/people/1/voices'),
      );
    });

    test('attributes that are missing parse as null', () {
      final person = Person.fromJson({
        'id': '9',
        'type': 'people',
        'attributes': {'name': 'Shinichiro Watanabe'},
      });

      expect(person.attributes!.name, equals('Shinichiro Watanabe'));
      expect(person.attributes!.malId, isNull);
      expect(person.attributes!.description, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Person.fromJson(personResource()).attributes!;
      final json = attrs.toJson();

      expect(json['name'], equals('Masahiko Minami'));
      expect(json['malId'], equals('Moved to mappings relationship.'));
      expect(json['description'], equals(' Wikipedia'));
      expect(json['createdAt'], equals('2013-02-20T18:49:20.441Z'));
      expect(json['updatedAt'], equals('2021-09-16T22:51:01.875Z'));
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = PersonResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = PersonResults.fromJson(singlePersonResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.name,
          equals('Masahiko Minami'));
    });

    test('PersonResult parses a single-object response', () {
      final result = PersonResult.fromJson(singlePersonResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.name, equals('Masahiko Minami'));
    });
  });

  group('PeopleMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late PeopleMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = PeopleMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is people', () {
      expect(methods.methodRadix, equals('people'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/people',
        () async {
      adapter.stub('GET', '/edge/people', body: loadFixture('people.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/people'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(35338));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

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
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: 'Masahiko Minami',
        slug: 'masahiko-minami',
        malId: 123,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[name]'], equals('Masahiko Minami'));
      expect(query['filter[slug]'], equals('masahiko-minami'));
      expect(query['filter[malId]'], equals(123));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

      await methods.fetchCollection(name: 'Masahiko Minami');

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[name]']));
      expect(query['filter[name]'], equals('Masahiko Minami'));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: 'Masahiko Minami',
        customFilters: [Filter('active', 'true')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[name]'], equals('Masahiko Minami'));
      expect(query['filter[active]'], equals('true'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 10, offset: 5),
        sorting: Sorting('name'),
        includes: Includes(['castings', 'staff']),
        sparseFieldSets: SparseFieldSets('people', ['name']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(10));
      expect(query['page[offset]'], equals(5));
      expect(query['sort'], equals('name'));
      expect(query['include'], equals('castings,staff'));
      expect(query['fields[people]'], equals('name'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/people', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/people/<id> and parses one person',
        () async {
      adapter.stub('GET', '/edge/people/1', body: singlePersonResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.path, equals('/edge/people/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.name, equals('Masahiko Minami'));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/people/1', body: singlePersonResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['staff']),
        sparseFieldSets: SparseFieldSets('people', ['name']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('staff'));
      expect(query['fields[people]'], equals('name'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('fetchBySlug filters by slug, asks for one and returns the person',
        () async {
      adapter.stub('GET', '/edge/people', body: singlePersonResponse());

      final person = await methods.fetchBySlug('masahiko-minami');

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[slug]'], equals('masahiko-minami'));
      expect(query['page[limit]'], equals(1));
      expect(person, isNotNull);
      expect(person!.attributes!.name, equals('Masahiko Minami'));
    });

    test('fetchBySlug returns null when nothing matches', () async {
      adapter.stub('GET', '/edge/people', body: {'data': <dynamic>[]});

      expect(await methods.fetchBySlug('does-not-exist'), isNull);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/people'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('charactersAndPeople exposes people', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.charactersAndPeople.people, isA<PeopleMethods>());
      expect(kitsumon.charactersAndPeople.people.methodRadix, equals('people'));
      expect(kitsumon.charactersAndPeople.people.api, same(kitsumon.api));
    });

    test('kitsumon.charactersAndPeople.people goes through the session client',
        () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/people', body: loadFixture('people.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results =
          await kitsumon.charactersAndPeople.people.fetchCollection();

      expect(results.data!.single.attributes!.name,
          equals('Masahiko Minami'));
    });
  });
}
