//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';
import '../support/fixture_files.dart';

/// Wraps a single-resource fixture into a collection document.
Map<String, dynamic> asCollection(Map<String, dynamic> single) => {
      'data': [single['data']],
    };

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  group('UsersMethods requests', () {
    test('fetchCollection sends filter[name] and the pagination', () async {
      final user = loadFixture('kitsu_user_1.json');
      adapter.stub('GET', '/edge/users', body: asCollection(user));
      final kitsu = createFakeKitsu(adapter);

      final results = await kitsu.users.fetchCollection(
        name: 'vikhyat',
        pagination: Pagination(limit: 5),
      );

      final request = adapter.lastRequest;
      expect(request.path, equals('/edge/users'));
      expect(request.queryParameters['filter[name]'], equals('vikhyat'));
      expect(
        request.queryParameters['page[limit]'].toString(),
        equals('5'),
      );
      expect(results.data, hasLength(1));
      expect(results.data!.single.attributes!.name, equals('vikhyat'));
    });

    test('fetchCollection sends nothing it was not given', () async {
      adapter.stub('GET', '/edge/users', body: {'data': <dynamic>[]});
      final kitsu = createFakeKitsu(adapter);

      await kitsu.users.fetchCollection();

      expect(adapter.lastRequest.uri.query, isEmpty);
    });

    test('fetchResource hits /edge/users/<id>', () async {
      final user = loadFixture('kitsu_user_1.json');
      adapter.stub('GET', '/edge/users/1', body: user);
      final kitsu = createFakeKitsu(adapter);

      final result = await kitsu.users.fetchResource(1);

      expect(adapter.lastRequest.path, equals('/edge/users/1'));
      expect(result.data!.id, equals(1));
      expect(result.data!.type, equals('users'));
    });

    test('fetchBySlug sends filter[slug] with a limit of one', () async {
      final user = loadFixture('kitsu_user_1.json');
      adapter.stub('GET', '/edge/users', body: asCollection(user));
      final kitsu = createFakeKitsu(adapter);

      final found = await kitsu.users.fetchBySlug('vikhyat');

      expect(adapter.lastRequest.queryParameters['filter[slug]'],
          equals('vikhyat'));
      expect(adapter.lastRequest.queryParameters['page[limit]'].toString(),
          equals('1'));
      expect(found!.attributes!.slug, equals('vikhyat'));
    });

    test('fetchBySlug returns null when nothing matches', () async {
      adapter.stub('GET', '/edge/users', body: {'data': <dynamic>[]});
      final kitsu = createFakeKitsu(adapter);

      expect(await kitsu.users.fetchBySlug('nobody'), isNull);
    });

    test('fetchCurrentUser refuses without authentication, sending nothing',
        () async {
      final kitsu = createFakeKitsu(adapter);

      await expectLater(
        kitsu.users.fetchCurrentUser(),
        throwsA(isA<KitsumonException>()),
      );
      expect(adapter.requests, isEmpty);
    });

    test('fetchCurrentUser sends filter[self]=true and returns data[0]',
        () async {
      final user = loadFixture('kitsu_user_1.json');
      adapter.stub('GET', '/edge/users', body: asCollection(user));
      final kitsu = createFakeKitsu(
        adapter,
        authentication: Authentication(accessToken: 'token'),
      );

      final result = await kitsu.users.fetchCurrentUser();

      expect(adapter.lastRequest.queryParameters['filter[self]'],
          equals('true'));
      expect(result.data!.attributes!.name, equals('vikhyat'));
    });
  });

  group('User model', () {
    test('parses the real /edge/users/1 payload', () {
      final user = User.fromJson(
        loadFixture('kitsu_user_1.json')['data'] as Map<String, dynamic>,
      );
      final attributes = user.attributes!;

      expect(user.id, equals(1));
      expect(attributes.name, equals('vikhyat'));
      expect(attributes.slug, equals('vikhyat'));
      expect(attributes.status, equals('registered'));
      expect(attributes.lifeSpentOnAnime, equals(45474));
      expect(attributes.createdAt, isNotNull);
      expect(attributes.proExpiresAt, isNotNull);
      expect(attributes.avatar, isNotNull);
      expect(attributes.avatar!['tiny'], isA<String>());
      expect(attributes.pastNames, isA<List<dynamic>>());
      expect(attributes.followersCount, isA<int>());
    });
  });
}
