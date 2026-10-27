//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// The first `streamingLinks` resource of `streaming_links.json`.
Map<String, dynamic> streamingLinkResource() =>
    (loadFixture('streaming_links.json')['data'] as List).first
        as Map<String, dynamic>;

/// What `GET /edge/streaming-links/1` answers: the resource alone under `data`.
Map<String, dynamic> singleStreamingLinkResponse() =>
    {'data': streamingLinkResource()};

void main() {
  group('StreamingLink models (streaming_links.json)', () {
    test('StreamingLinkResults keeps data, meta and links of the fixture', () {
      final results =
          StreamingLinkResults.fromJson(loadFixture('streaming_links.json'));

      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(7781));
      expect(results.links!.first, contains('streaming-links'));
      expect(results.links!.next, contains('page%5Boffset%5D=1'));
    });

    test('StreamingLink parses the envelope of the resource', () {
      final link = StreamingLinkResults.fromJson(
              loadFixture('streaming_links.json'))
          .data!
          .first;

      expect(link.id, equals(1));
      expect(link.type, equals('streamingLinks'));
      expect(link.link,
          equals('https://kitsu.io/api/edge/streaming-links/1'));
    });

    test('StreamingLinkAttributes parses every attribute with its type', () {
      final attrs = StreamingLinkResults.fromJson(
              loadFixture('streaming_links.json'))
          .data!
          .first
          .attributes!;

      expect(attrs.url,
          equals('http://www.hulu.com/hacklegend-of-the-twilight'));
      expect(attrs.subs, equals(['en']));
      expect(attrs.dubs, equals(['ja']));
      expect(attrs.createdAt, isNull);
      expect(attrs.updatedAt, isNull);
    });

    test('relationships keep the links of streamer and media', () {
      final relationships = StreamingLinkResults.fromJson(
              loadFixture('streaming_links.json'))
          .data!
          .first
          .relationships!;

      expect(
        relationships.streamer!.links!.related,
        equals('https://kitsu.io/api/edge/streaming-links/1/streamer'),
      );
      expect(
        relationships.media!.links!.related,
        equals('https://kitsu.io/api/edge/streaming-links/1/media'),
      );
    });

    test('attributes that are missing parse as null', () {
      final link = StreamingLink.fromJson({
        'id': '9',
        'type': 'streamingLinks',
        'attributes': {'url': 'https://crunchyroll.com'},
      });

      expect(link.attributes!.url, equals('https://crunchyroll.com'));
      expect(link.attributes!.subs, isNull);
      expect(link.attributes!.dubs, isNull);
    });

    test('attributes serialize back with the same keys', () {
      final attrs =
          StreamingLink.fromJson(streamingLinkResource()).attributes!;

      expect(
        attrs.toJson(),
        equals({
          'url': 'http://www.hulu.com/hacklegend-of-the-twilight',
          'subs': ['en'],
          'dubs': ['ja'],
        }),
      );
    });

    test('an empty collection (data: []) is an empty result', () {
      final results = StreamingLinkResults.fromJson({
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test('a single-object response is parsed like a collection of one', () {
      final results =
          StreamingLinkResults.fromJson(singleStreamingLinkResponse());

      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.subs, equals(['en']));
    });

    test('StreamingLinkResult parses a single-object response', () {
      final result =
          StreamingLinkResult.fromJson(singleStreamingLinkResponse());

      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.dubs, equals(['ja']));
    });
  });

  group('StreamingLinksMethods requests', () {
    late FakeHttpClientAdapter adapter;
    late StreamingLinksMethods methods;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      methods = StreamingLinksMethods(createFakeKitsu(adapter));
    });

    test('methodRadix is streaming-links', () {
      expect(methods.methodRadix, equals('streaming-links'));
    });

    test(
        'fetchCollection with no argument sends a bare GET /edge/streaming-links',
        () async {
      adapter.stub('GET', '/edge/streaming-links',
          body: loadFixture('streaming_links.json'));

      final results = await methods.fetchCollection();

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/streaming-links'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(results.data, hasLength(1));
      expect(results.meta!.count, equals(7781));
    });

    test('fetchCollection sends null and empty parameters nowhere', () async {
      adapter.stub('GET', '/edge/streaming-links', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaType: null,
        mediaId: null,
        streamerId: null,
        customFilters: null,
        pagination: null,
        sorting: null,
        includes: null,
        sparseFieldSets: null,
      );

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchCollection sends every filter under its API key', () async {
      adapter.stub('GET', '/edge/streaming-links', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaType: 'Anime',
        mediaId: 100,
        streamerId: 5,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mediaType]'], equals('Anime'));
      expect(query['filter[mediaId]'], equals(100));
      expect(query['filter[streamerId]'], equals(5));
    });

    test('fetchCollection sends only the filters that were given', () async {
      adapter.stub('GET', '/edge/streaming-links', body: {'data': <dynamic>[]});

      await methods.fetchCollection(mediaId: 42);

      final query = adapter.lastRequest.queryParameters;
      expect(query.keys, equals(['filter[mediaId]']));
      expect(query['filter[mediaId]'], equals(42));
    });

    test('fetchCollection forwards custom filters', () async {
      adapter.stub('GET', '/edge/streaming-links', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        mediaId: 42,
        customFilters: [Filter('subs', 'en')],
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['filter[mediaId]'], equals(42));
      expect(query['filter[subs]'], equals('en'));
    });

    test('fetchCollection sends sorting, pagination, include and fields',
        () async {
      adapter.stub('GET', '/edge/streaming-links', body: {'data': <dynamic>[]});

      await methods.fetchCollection(
        pagination: Pagination(limit: 10, offset: 5),
        sorting: Sorting('url'),
        includes: Includes(['media', 'streamer']),
        sparseFieldSets:
            SparseFieldSets('streaming-links', ['url', 'subs']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['page[limit]'], equals(10));
      expect(query['page[offset]'], equals(5));
      expect(query['sort'], equals('url'));
      expect(query['include'], equals('media,streamer'));
      expect(query['fields[streaming-links]'], equals('url,subs'));
    });

    test('fetchCollection returns an empty result for data: []', () async {
      adapter.stub('GET', '/edge/streaming-links', body: {
        'data': <dynamic>[],
        'meta': {'count': 0},
      });

      final results = await methods.fetchCollection();

      expect(results.data, isEmpty);
      expect(results.meta!.count, equals(0));
    });

    test(
        'fetchResource asks for /edge/streaming-links/<id> and parses one streaming link',
        () async {
      adapter.stub('GET', '/edge/streaming-links/1',
          body: singleStreamingLinkResponse());

      final result = await methods.fetchResource(1);

      expect(adapter.lastRequest.path, equals('/edge/streaming-links/1'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
      expect(result.data!.id, equals(1));
      expect(result.data!.attributes!.url,
          equals('http://www.hulu.com/hacklegend-of-the-twilight'));
    });

    test('fetchResource sends include and fields, and no filters', () async {
      adapter.stub('GET', '/edge/streaming-links/1',
          body: singleStreamingLinkResponse());

      await methods.fetchResource(
        1,
        includes: Includes(['streamer']),
        sparseFieldSets: SparseFieldSets('streaming-links', ['url']),
      );

      final query = adapter.lastRequest.queryParameters;
      expect(query['include'], equals('streamer'));
      expect(query['fields[streaming-links]'], equals('url'));
      expect(query.keys.where((k) => k.startsWith('filter[')), isEmpty);
    });

    test('an unstubbed request throws instead of reaching the network',
        () async {
      await expectLater(
        methods.fetchCollection(),
        throwsA(isA<DioException>().having(
            (e) => e.error, 'error', isA<UnstubbedRequestError>())),
      );
      expect(adapter.requests.single.path, equals('/edge/streaming-links'));
    });
  });

  group('Kitsumon aggregator wiring', () {
    test('media exposes streamingLinks', () {
      final kitsumon =
          Kitsumon(kitsu: createFakeKitsu(FakeHttpClientAdapter()));

      expect(kitsumon.media.streamingLinks, isA<StreamingLinksMethods>());
      expect(kitsumon.media.streamingLinks.methodRadix,
          equals('streaming-links'));
      expect(kitsumon.media.streamingLinks.api, same(kitsumon.api));
    });

    test('kitsumon.media.streamingLinks goes through the session client',
        () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('GET', '/edge/streaming-links',
            body: loadFixture('streaming_links.json'));
      final kitsumon = Kitsumon(kitsu: createFakeKitsu(adapter));

      final results = await kitsumon.media.streamingLinks.fetchCollection();

      expect(results.data!.single.attributes!.subs, equals(['en']));
    });
  });
}
