//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  group('AuthenticationMethod.viaPasswordGrant', () {
    test('posts the password grant and parses the token response', () async {
      adapter.stub('POST', '/oauth/token', body: {
        'access_token': 'abc',
        'token_type': 'bearer',
        'expires_in': 2592000,
        'refresh_token': 'def',
        'scope': 'public',
        'created_at': 1700000000,
      });
      final method = AuthenticationMethod(createFakeKitsuClient(adapter));

      final authentication = await method.viaPasswordGrant(
        username: 'fox',
        password: 'hunter2',
      );

      expect(adapter.lastRequest.method, equals('POST'));
      expect(adapter.lastRequest.path, equals('/oauth/token'));
      expect(adapter.lastRequest.data, equals({
        'grant_type': 'password',
        'username': 'fox',
        'password': 'hunter2',
      }));
      expect(authentication.accessToken, equals('abc'));
      expect(authentication.refreshToken, equals('def'));
      expect(authentication.expiresIn, equals(const Duration(seconds: 2592000)));
      expect(authentication.scope, equals('public'));
    });

    test('the obtained token authenticates the next session', () async {
      adapter
        ..stub('POST', '/oauth/token', body: {'access_token': 'abc'})
        ..stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
      final authentication = await AuthenticationMethod(
        createFakeKitsuClient(adapter),
      ).viaPasswordGrant(username: 'fox', password: 'pw');

      final kitsu = createFakeKitsu(adapter, authentication: authentication);
      await Kitsumon(kitsu: kitsu).media.anime.fetchCollection();

      expect(kitsu.authenticated, isTrue);
      expect(adapter.lastRequest.header('Authorization'), equals('Bearer abc'));
    });

    test('a rejected grant surfaces as an ApiException', () async {
      adapter.stubJsonApiError('POST', '/oauth/token',
          statusCode: 401,
          errors: [
            {
              'title': 'Invalid grant',
              'detail': 'The provided authorization grant is invalid.',
              'status': '401',
            },
          ]);
      final method = AuthenticationMethod(createFakeKitsuClient(adapter));

      await expectLater(
        method.viaPasswordGrant(username: 'fox', password: 'wrong'),
        throwsA(isA<ApiException>()
            .having((e) => e.title, 'title', 'Invalid grant')
            .having((e) => e.status, 'status', 401)),
      );
    });
  });
}
