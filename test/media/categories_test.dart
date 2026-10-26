//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `categories` resource of `categories.json`.
Map<String, dynamic> categoryResource() =>
    (loadFixture('categories.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/categories/1` answers: the resource alone under `data`.
Map<String, dynamic> singleCategoryResponse() => {'data': categoryResource()};

void main() {
  group('Category models (categories.json)', () {
    test('CategoryResults keeps data, meta and links of the fixture', () {
      final results = CategoryResults.fromJson(loadFixture('categories.json'));

      expect(results.data, hasLength(2));
      expect(results.meta!.count, equals(218));
      expect(results.links!.first, contains('categories'));
      expect(results.links!.next, contains('page%5Boffset%5D=2'));
    });

    test('Category parses the envelope of the first resource', () {
      final category =
          CategoryResults.fromJson(loadFixture('categories.json')).data!.first;

      expect(category.id, equals(1));
      expect(category.type, equals('categories'));
      expect(category.link, equals('https://kitsu.io/api/edge/categories/1'));
    });

    test('CategoryAttributes parses every attribute with its type', () {
      final attrs = CategoryResults.fromJson(loadFixture('categories.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.title, equals('Middle School'));
      expect(attrs.slug, equals('middle-school'));
      expect(attrs.description, isEmpty);
      expect(attrs.totalMediaCount, isA<int>());
      expect(attrs.totalMediaCount, equals(111));
      expect(attrs.childCount, isA<int>());
      expect(attrs.childCount, equals(0));
      expect(attrs.nsfw, isA<bool>());
      expect(attrs.nsfw, isFalse);
      expect(attrs.createdAt, equals('2017-05-31T06:38:28.636Z'));
      expect(attrs.updatedAt, equals('2021-10-02T01:31:01.196Z'));
    });

    test('the second resource of the fixture is parsed too', () {
      final category =
          CategoryResults.fromJson(loadFixture('categories.json')).data!.last;

      expect(category.id, equals(2));
      expect(category.attributes!.title, equals('Cycling'));
      expect(category.attributes!.slug, equals('cycling'));
      expect(category.attributes!.totalMediaCount, equals(19));
    });

    test('a nsfw category parses its boolean as true', () {
      final resource = categoryResource();
      (resource['attributes'] as Map<String, dynamic>)['nsfw'] = true;

      expect(Category.fromJson(resource).attributes!.nsfw, isTrue);
    });

    test('attributes that are missing parse as null', () {
      final category = Category.fromJson({
        'id': '9',
        'type': 'categories',
        'attributes': {'title': 'Only a title'},
      });

      expect(category.attributes!.title, equals('Only a title'));
      expect(category.attributes!.nsfw, isNull);
      expect(category.attributes!.totalMediaCount, isNull);
      expect(category.attributes!.childCount, isNull);
    });

    test('relationships keep the links of parent, anime, drama and manga',
        () {
      final relationships =
          CategoryResults.fromJson(loadFixture('categories.json'))
              .data!
              .first
              .relationships!;

      expect(relationships.parent!.links!.related,
          equals('https://kitsu.io/api/edge/categories/1/parent'));
      expect(relationships.anime!.links!.self,
          equals('https://kitsu.io/api/edge/categories/1/relationships/anime'));
      expect(relationships.drama!.links!.related,
          equals('https://kitsu.io/api/edge/categories/1/drama'));
      expect(relationships.manga!.links!.related,
          equals('https://kitsu.io/api/edge/categories/1/manga'));
    });

    test('attributes serialize back with the same keys and types', () {
      final attrs = Category.fromJson(categoryResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'createdAt': '2017-05-31T06:38:28.636Z',
          'updatedAt': '2021-10-02T01:31:01.196Z',
          'title': 'Middle School',
          'slug': 'middle-school',
          'description': '',
          'totalMediaCount': 111,
          'childCount': 0,
          'nsfw': false,
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = CategoryResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = CategoryResults.fromJson(singleCategoryResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.title, equals('Middle School'));
    });

    test('CategoryResult parses a single-object response', () {
      final result = CategoryResult.fromJson(singleCategoryResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.nsfw, isFalse);
    });
  });

  group('CategoriesMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late CategoriesMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = CategoriesMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is categories', () {
      expect(methods.methodRadix, equals('categories'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/categories',
        () async {
      adapter.stub('GET', '/edge/categories',
          body: loadFixture('categories.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/categories'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(2));
      expect(results.data!.first.attributes!.title, equals('Middle School'));
      expect(results.meta!.count, equals(218));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/categories', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        title: null,
        slug: null,
        parent: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(adapter.lastRequest.uri.query, isEmpty);

      await methods.fetchCollection(
        title: '',
        slug: '',
        parent: '',
        customFilters: const [],
      );
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends title, slug and parent under filter[...]',
        () async {
      adapter.stub('GET', '/edge/categories', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        title: 'Cycling',
        slug: 'cycling',
        parent: 'sports',
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'filter[title]': 'Cycling',
          'filter[slug]': 'cycling',
          'filter[parent]': 'sports',
        }),
      );
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/categories', body: {'data': <dynamic>[]});

      await methods.fetchCollection(parent: 'sports');

      expect(adapter.lastRequest.queryParameters,
          equals({'filter[parent]': 'sports'}));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/categories', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        title: 'Cycling',
        customFilters: [Filter('nsfw', false)],
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({'filter[title]': 'Cycling', 'filter[nsfw]': false}),
      );
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/categories', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        sorting: Sorting('totalMediaCount', descending: true),
        pagination: Pagination(limit: 2, offset: 4),
        includes: Includes(['parent']),
        sparseFieldSets: SparseFieldSets('categories', ['title', 'slug']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'sort': '-totalMediaCount',
          'page[limit]': 2,
          'page[offset]': 4,
          'include': 'parent',
          'fields[categories]': 'title,slug',
        }),
      );
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/categories',
          body: {'data': <dynamic>[], 'meta': {'count': 0}});

      final results = await methods.fetchCollection(title: 'nothing');

      expect(results.data, isEmpty);
    });

    test('a single-object response reads as a collection of one', () async {
      adapter.stub('GET', '/edge/categories', body: singleCategoryResponse());

      final results = await methods.fetchCollection(slug: 'middle-school');

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.slug, equals('middle-school'));
    });

    test('fetchResource asks for /edge/categories/<id> and parses one',
        () async {
      adapter.stub('GET', '/edge/categories/1',
          body: singleCategoryResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/categories/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.title, equals('Middle School'));
      expect(result.data!.attributes!.nsfw, isFalse);
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/categories/1',
          body: singleCategoryResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['parent']),
        sparseFieldSets: SparseFieldSets('categories', ['title']),
      );

      expect(
        adapter.lastRequest.queryParameters,
        equals({'include': 'parent', 'fields[categories]': 'title'}),
      );
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes categories', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.categories, isA<CategoriesMethods>());
      expect(kitsumon.media.categories.methodRadix, equals('categories'));
      expect(kitsumon.media.categories.api, same(kitsumon.api));
    });

    test('kitsumon.media.categories goes through the session client',
        () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/categories', body: loadFixture('categories.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.categories.fetchCollection();

      expect(results.data!.last.attributes!.slug, equals('cycling'));
    });
  });
}
