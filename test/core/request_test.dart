//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:kitsumon/src/core/request.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixtures.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late AnimeMethods caller;

  setUp(() {
    adapter = FakeHttpClientAdapter()
      ..stub('GET', '/edge/anime', body: animeCollectionResponse())
      ..stub('GET', '/edge/anime/7', body: {'data': animeResource()});
    caller = AnimeMethods(createFakeKitsu(adapter));
  });

  group('Request.get', () {
    test('sends no query parameters when nothing was asked for', () async {
      await Request(caller).get();

      expect(adapter.lastRequest.path, equals('/edge/anime'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
    });

    test('merges filters, pagination, sorting, includes and sparse fieldsets',
        () async {
      await Request(
        caller,
        filters: [Filter('slug', 'cowboy-bebop'), Filter('genres', ['a', 'b'])],
        pagination: Pagination(limit: 5, offset: 10),
        sorting: Sorting('userCount', descending: true),
        includes: Includes(['genres']),
        sparseFieldSets: SparseFieldSets('anime', ['slug']),
      ).get();

      expect(
        adapter.lastRequest.queryParameters,
        equals({
          'filter[slug]': 'cowboy-bebop',
          'filter[genres]': 'a,b',
          'page[limit]': 5,
          'page[offset]': 10,
          'sort': '-userCount',
          'include': 'genres',
          'fields[anime]': 'slug',
        }),
      );
    });

    test('skips filters whose value is null', () async {
      await Request(caller, filters: [Filter('slug', null), Filter('text', 'x')])
          .get();

      expect(adapter.lastRequest.queryParameters, equals({'filter[text]': 'x'}));
    });

    test('returns the decoded JSON:API document', () async {
      final response = await Request(caller).get();

      expect((response as Map)['meta'], equals({'count': 1}));
    });
  });

  group('Request.fetch', () {
    test('requests /<radix>/<id>', () async {
      await Request(caller).fetch(7);

      expect(adapter.lastRequest.method, equals('GET'));
      expect(adapter.lastRequest.path, equals('/edge/anime/7'));
      expect(adapter.lastRequest.queryParameters, isEmpty);
    });

    test('only forwards includes and sparse fieldsets', () async {
      await Request(
        caller,
        filters: [Filter('slug', 'x')],
        pagination: Pagination(limit: 5),
        sorting: Sorting('slug'),
        includes: Includes(['genres']),
        sparseFieldSets: SparseFieldSets('anime', ['slug']),
      ).fetch(7);

      expect(
        adapter.lastRequest.queryParameters,
        equals({'include': 'genres', 'fields[anime]': 'slug'}),
      );
    });
  });

  group('Request errors', () {
    test('an API error reaches the caller as an ApiException', () async {
      adapter.stubJsonApiError('GET', '/edge/anime/7',
          statusCode: 404,
          errors: [
            {
              'title': 'The requested record was not found',
              'detail': 'No record 7.',
              'code': '404',
              'status': '404',
            },
          ]);

      await expectLater(
        Request(caller).fetch(7),
        throwsA(isA<ApiException>().having((e) => e.status, 'status', 404)),
      );
    });
  });
}
