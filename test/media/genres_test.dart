//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `genres` resource of `genres.json`.
Map<String, dynamic> genreResource() =>
    (loadFixture('genres.json')['data'] as List).first as Map<String, dynamic>;

/// What `GET /edge/genres/1` answers: the resource alone under `data`.
Map<String, dynamic> singleGenreResponse() => {'data': genreResource()};

void main() {
  group('Genre models (genres.json)', () {
    test('GenreResults keeps data, meta and links of the fixture', () {
      final results = GenreResults.fromJson(loadFixture('genres.json'));

      expect(results.data, hasLength(2));
      expect(results.meta!.count, equals(62));
      expect(results.links!.first, contains('genres'));
      expect(results.links!.next, contains('page%5Boffset%5D=2'));
    });

    test('Genre parses the envelope of the first resource', () {
      final genre = GenreResults.fromJson(loadFixture('genres.json')).data!.first;

      expect(genre.id, equals(1));
      expect(genre.type, equals('genres'));
      expect(genre.link, equals('https://kitsu.io/api/edge/genres/1'));
      expect(genre.relationships, isNull);
    });

    test('GenreAttributes parses every attribute', () {
      final attrs = GenreResults.fromJson(loadFixture('genres.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.name, equals('Action'));
      expect(attrs.slug, equals('action'));
      expect(attrs.description, isEmpty);
      expect(attrs.createdAt, equals('2013-02-20T16:00:15.623Z'));
      expect(attrs.updatedAt, equals('2016-07-17T19:30:56.164Z'));
    });

    test('the second resource of the fixture is parsed too', () {
      final genre = GenreResults.fromJson(loadFixture('genres.json')).data!.last;

      expect(genre.id, equals(2));
      expect(genre.attributes!.name, equals('Adventure'));
      expect(genre.attributes!.slug, equals('adventure'));
    });

    test('attributes that are missing parse as null', () {
      final genre = Genre.fromJson({
        'id': '9',
        'type': 'genres',
        'attributes': {'name': 'Only a name'},
      });

      expect(genre.attributes!.name, equals('Only a name'));
      expect(genre.attributes!.slug, isNull);
      expect(genre.attributes!.description, isNull);
    });

    test('relationships, when the API sends them, keep their links', () {
      final resource = genreResource();
      resource['relationships'] = {
        'anime': {
          'links': {'related': 'https://kitsu.io/api/edge/genres/1/anime'},
        },
      };

      final genre = Genre.fromJson(resource);

      expect(genre.relationships!['anime']!.links!.related,
          equals('https://kitsu.io/api/edge/genres/1/anime'));
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Genre.fromJson(genreResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'createdAt': '2013-02-20T16:00:15.623Z',
          'updatedAt': '2016-07-17T19:30:56.164Z',
          'name': 'Action',
          'slug': 'action',
          'description': '',
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = GenreResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = GenreResults.fromJson(singleGenreResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.name, equals('Action'));
    });

    test('GenreResult parses a single-object response', () {
      final result = GenreResult.fromJson(singleGenreResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.slug, equals('action'));
    });
  });

  group('GenresMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late GenresMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = GenresMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is genres', () {
      expect(methods.methodRadix, equals('genres'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/genres',
        () async {
      adapter.stub('GET', '/edge/genres', body: loadFixture('genres.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/genres'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(2));
      expect(results.data!.first.attributes!.name, equals('Action'));
      expect(results.meta!.count, equals(62));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/genres', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: null,
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
        name: '',
        slug: '',
        customFilters: const [],
      );
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends name and slug under filter[...]', () async {
      adapter.stub('GET', '/edge/genres', body: {'data': <dynamic>[]});

      await methods.fetchCollection(name: 'Action', slug: 'action');

      expect(
        adapter.lastRequest.queryParameters,
        equals({'filter[name]': 'Action', 'filter[slug]': 'action'}),
      );
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/genres', body: {'data': <dynamic>[]});

      await methods.fetchCollection(slug: 'action');

      expect(adapter.lastRequest.queryParameters,
          equals({'filter[slug]': 'action'}));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/genres', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        name: 'Action',
        customFilters: [Filter('description', 'x')],
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({'filter[name]': 'Action', 'filter[description]': 'x'}),
      );
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/genres', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        sorting: Sorting('name'),
        pagination: Pagination(limit: 2, offset: 2),
        includes: Includes(['anime']),
        sparseFieldSets: SparseFieldSets('genres', ['name']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'sort': 'name',
          'page[limit]': 2,
          'page[offset]': 2,
          'include': 'anime',
          'fields[genres]': 'name',
        }),
      );
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/genres',
          body: {'data': <dynamic>[], 'meta': {'count': 0}});

      final results = await methods.fetchCollection(name: 'nothing');

      expect(results.data, isEmpty);
    });

    test('a single-object response reads as a collection of one', () async {
      adapter.stub('GET', '/edge/genres', body: singleGenreResponse());

      final results = await methods.fetchCollection(slug: 'action');

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.slug, equals('action'));
    });

    test('fetchResource asks for /edge/genres/<id> and parses one genre',
        () async {
      adapter.stub('GET', '/edge/genres/1', body: singleGenreResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/genres/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.name, equals('Action'));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/genres/1', body: singleGenreResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['anime']),
        sparseFieldSets: SparseFieldSets('genres', ['name']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({'include': 'anime', 'fields[genres]': 'name'}),
      );
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes genres', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.genres, isA<GenresMethods>());
      expect(kitsumon.media.genres.methodRadix, equals('genres'));
      expect(kitsumon.media.genres.api, same(kitsumon.api));
    });

    test('kitsumon.media.genres goes through the session client', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/genres', body: loadFixture('genres.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.genres.fetchCollection();

      expect(results.data!.last.attributes!.slug, equals('adventure'));
    });
  });
}
