//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  Kitsu authenticated() => createFakeKitsu(
        adapter,
        authentication: Authentication(accessToken: 'token'),
      );

  group('fetchCollection', () {
    test('sends the user, media, kind and status filters plus include=media',
        () async {
      adapter.stub('GET', '/edge/library-entries', body: {
        'data': <dynamic>[],
      });
      final kitsu = createFakeKitsu(adapter);

      await kitsu.libraryEntries.fetchCollection(
        userId: 7,
        mediaType: 'anime',
        kind: 'anime',
        statuses: [LibraryEntryStatus.current, LibraryEntryStatus.planned],
        includeMedia: true,
      );

      final query = adapter.lastRequest.queryParameters;
      expect(adapter.lastRequest.path, equals('/edge/library-entries'));
      expect(query['filter[userId]'].toString(), equals('7'));
      expect(query['filter[mediaType]'], equals('anime'));
      expect(query['filter[kind]'], equals('anime'));
      expect(query['filter[status]'], equals('current,planned'));
      expect(query['include'], equals('media'));
    });

    test('omits everything it was not given', () async {
      adapter.stub('GET', '/edge/library-entries', body: {'data': <dynamic>[]});
      final kitsu = createFakeKitsu(adapter);

      await kitsu.libraryEntries.fetchCollection();

      expect(adapter.lastRequest.uri.query, isEmpty);
    });
  });

  group('resources', () {
    test('fetchResource parses the documented payload', () async {
      adapter.stub('GET', '/edge/library-entries/42',
          body: loadFixture('library_entry_1.json'));
      final kitsu = createFakeKitsu(adapter);

      final result = await kitsu.libraryEntries.fetchResource(42);
      final attributes = result.data!.attributes!;

      expect(adapter.lastRequest.path, equals('/edge/library-entries/42'));
      expect(result.data!.id, equals(42));
      expect(attributes.progress, equals(12));
      expect(attributes.status, equals('current'));
      expect(attributes.typedStatus, equals(LibraryEntryStatus.current));
      expect(attributes.ratingTwenty, equals(18));
      expect(attributes.rating, equals(4.5));
      expect(attributes.reconsumeCount, equals(1));
      expect(attributes.private, isFalse);
    });

    test('an unknown status stays readable as a raw string', () {
      final attributes = LibraryEntryAttributes.fromJson(const {
        'status': 'abandoned',
        'progress': 3,
      });

      expect(attributes.typedStatus, isNull);
      expect(attributes.status, equals('abandoned'));
    });
  });

  group('writes', () {
    test('createResource posts a JSON:API document with both relationships',
        () async {
      adapter.stub('POST', '/edge/library-entries',
          body: loadFixture('library_entry_1.json'), statusCode: 201);
      final kitsu = authenticated();

      final result = await kitsu.libraryEntries.createResource(
        userId: 7,
        mediaId: 1,
        mediaType: 'anime',
        status: LibraryEntryStatus.current,
        progress: 12,
        ratingTwenty: 18,
      );

      final body = adapter.lastRequest.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      expect(adapter.lastRequest.method, equals('POST'));
      expect(adapter.lastRequest.path, equals('/edge/library-entries'));
      expect(data['type'], equals('libraryEntries'));
      expect(data['attributes'], equals({
        'status': 'current',
        'progress': 12,
        'ratingTwenty': 18,
      }));
      final relationships = data['relationships'] as Map<String, dynamic>;
      expect(
        (relationships['user'] as Map<String, dynamic>)['data'],
        equals({'type': 'users', 'id': '7'}),
      );
      expect(
        (relationships['media'] as Map<String, dynamic>)['data'],
        equals({'type': 'anime', 'id': '1'}),
      );
      expect(result.data!.id, equals(42));
    });

    test('updateResource patches only the attributes that changed', () async {
      adapter.stub('PATCH', '/edge/library-entries/42',
          body: loadFixture('library_entry_1.json'));
      final kitsu = authenticated();

      await kitsu.libraryEntries.updateResource(42, progress: 13);

      final body = adapter.lastRequest.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      expect(adapter.lastRequest.method, equals('PATCH'));
      expect(adapter.lastRequest.path, equals('/edge/library-entries/42'));
      expect(data['id'], equals('42'));
      expect(data['attributes'], equals({'progress': 13}));
    });

    test('deleteResource deletes the entry', () async {
      adapter.stub('DELETE', '/edge/library-entries/42',
          body: <String, dynamic>{}, statusCode: 204);
      final kitsu = authenticated();

      final deleted = await kitsu.libraryEntries.deleteResource(42);

      expect(deleted, isTrue);
      expect(adapter.lastRequest.method, equals('DELETE'));
      expect(adapter.lastRequest.path, equals('/edge/library-entries/42'));
    });

    test('every write refuses without authentication, sending nothing',
        () async {
      final kitsu = createFakeKitsu(adapter);

      await expectLater(
        kitsu.libraryEntries.createResource(
          userId: 7,
          mediaId: 1,
          mediaType: 'anime',
        ),
        throwsA(isA<KitsumonException>()),
      );
      await expectLater(
        kitsu.libraryEntries.updateResource(42, progress: 1),
        throwsA(isA<KitsumonException>()),
      );
      await expectLater(
        kitsu.libraryEntries.deleteResource(42),
        throwsA(isA<KitsumonException>()),
      );

      expect(adapter.requests, isEmpty);
    });
  });
}
