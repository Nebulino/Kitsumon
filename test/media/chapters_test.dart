//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `chapters` resource of `chapters.json`.
Map<String, dynamic> chapterResource() =>
    (loadFixture('chapters.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/chapters/2` answers: the resource alone under `data`.
Map<String, dynamic> singleChapterResponse() => {'data': chapterResource()};

void main() {
  group('Chapter models (chapters.json)', () {
    test('ChapterResults keeps data, meta and links of the fixture', () {
      final results = ChapterResults.fromJson(loadFixture('chapters.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(4998974));
      expect(results.links!.first, contains('chapters'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('Chapter parses the envelope of the resource', () {
      final chapter =
          ChapterResults.fromJson(loadFixture('chapters.json')).data!.first;

      expect(chapter.id, equals(2));
      expect(chapter.type, equals('chapters'));
      expect(chapter.link, equals('https://kitsu.io/api/edge/chapters/2'));
    });

    test('ChapterAttributes parses every attribute with its type', () {
      final attrs = ChapterResults.fromJson(loadFixture('chapters.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.number, equals(1));
      expect(attrs.volumeNumber, equals(1));
      expect(attrs.synopsis, isEmpty);
      expect(attrs.description, isEmpty);
      expect(attrs.canonicalTitle, isNull);
      expect(attrs.published, isNull);
      expect(attrs.length, isNull);
      expect(attrs.thumbnail, isNull);
      expect(attrs.titles, isEmpty);
      expect(attrs.createdAt, equals('2017-06-30T16:07:59.731Z'));
      expect(attrs.updatedAt, equals('2018-11-28T23:13:26.149Z'));
    });

    test('relationships keep the links of manga', () {
      final relationships =
          ChapterResults.fromJson(loadFixture('chapters.json'))
              .data!
              .first
              .relationships!;

      expect(
        relationships.manga!.links!.related,
        equals('https://kitsu.io/api/edge/chapters/2/manga'),
      );
    });

    test('attributes that are missing parse as null', () {
      final chapter = Chapter.fromJson({
        'id': '9',
        'type': 'chapters',
        'attributes': {'number': 10},
      });

      expect(chapter.attributes!.number, equals(10));
      expect(chapter.attributes!.volumeNumber, isNull);
      expect(chapter.attributes!.canonicalTitle, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs = Chapter.fromJson(chapterResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'createdAt': '2017-06-30T16:07:59.731Z',
          'updatedAt': '2018-11-28T23:13:26.149Z',
          'synopsis': '',
          'description': '',
          'titles': <String, dynamic>{},
          'volumeNumber': 1,
          'number': 1,
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = ChapterResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results = ChapterResults.fromJson(singleChapterResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.number, equals(1));
    });

    test('ChapterResult parses a single-object response', () {
      final result = ChapterResult.fromJson(singleChapterResponse());

      expect(result.data!.id, equals(2));
      expect(result.data!.attributes!.volumeNumber, equals(1));
    });
  });

  group('ChaptersMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late ChaptersMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = ChaptersMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is chapters', () {
      expect(methods.methodRadix, equals('chapters'));
    });

    test('fetchCollection with no argument sends a bare GET /edge/chapters',
        () async {
      adapter.stub('GET', '/edge/chapters',
          body: loadFixture('chapters.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/chapters'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.data!.first.attributes!.number, equals(1));
      expect(results.meta!.count, equals(4998974));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/chapters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mangaId: null,
        number: null,
        volumeNumber: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/chapters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mangaId: 55,
        number: 4,
        volumeNumber: 2,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mangaId]'], equals(55));
      expect(query['filter[number]'], equals(4));
      expect(query['filter[volumeNumber]'], equals(2));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/chapters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(mangaId: 99);

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[mangaId]']));
      expect(query['filter[mangaId]'], equals(99));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/chapters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mangaId: 99,
        customFilters: [Filter('special', 'true')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mangaId]'], equals(99));
      expect(query['filter[special]'], equals('true'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/chapters', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 5, offset: 10),
        sorting: Sorting('number'),
        includes: Includes(['manga']),
        sparseFieldSets: SparseFieldSets('chapters', ['canonicalTitle', 'number']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(5));
      expect(query['page[offset]'], equals(10));
      expect(query['sort'], equals('number'));
      expect(query['include'], equals('manga'));
      expect(query['fields[chapters]'], equals('canonicalTitle,number'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/chapters', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('fetchResource asks for /edge/chapters/<id> and parses one chapter',
        () async {
      adapter.stub('GET', '/edge/chapters/2', body: singleChapterResponse());

      final result = await methods.fetchResource(2);

      expect(adapter.lastRequest.path, equals('/edge/chapters/2'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(2));
      expect(result.data!.attributes!.volumeNumber, equals(1));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/chapters/2', body: singleChapterResponse());

      await methods.fetchResource(
        2,
        includes: Includes(['manga']),
        sparseFieldSets: SparseFieldSets('chapters', ['number']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('manga'));
      expect(query['fields[chapters]'], equals('number'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/chapters'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes chapters', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.chapters, isA<ChaptersMethods>());
      expect(kitsumon.media.chapters.methodRadix, equals('chapters'));
      expect(kitsumon.media.chapters.api, same(kitsumon.api));
    });

    test('kitsumon.media.chapters goes through the session client', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/chapters', body: loadFixture('chapters.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.chapters.fetchCollection();

      expect(results.data!.single.attributes!.number, equals(1));
    });
  });
}
