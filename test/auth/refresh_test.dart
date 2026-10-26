//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

/// A client whose network layer is [adapter] and whose refresh callback is
/// [onUnauthorized].
KitsuClient clientWith(
  FakeHttpClientAdapter adapter, {
  String? accessToken = 'old-token',
  Future<Authentication?> Function()? onUnauthorized,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))
    ..httpClientAdapter = adapter;

  return KitsuClient(
    dio: dio,
    authentication: accessToken == null
        ? null
        : Authentication(accessToken: accessToken),
    onUnauthorized: onUnauthorized,
  );
}

void main() {
  late FakeHttpClientAdapter adapter;

  setUp(() => adapter = FakeHttpClientAdapter());

  group('Authentication', () {
    test('parses token_type into tokenType', () {
      final authentication = Authentication.fromJson(const {
        'access_token': 'access',
        'token_type': 'bearer',
        'expires_in': 3600,
        'created_at': 1600000000,
        'refresh_token': 'refresh',
        'scope': 'public',
      });

      expect(authentication.tokenType, equals('bearer'));
      expect(authentication.accessToken, equals('access'));
      expect(authentication.refreshToken, equals('refresh'));
      expect(authentication.expiresIn, equals(const Duration(hours: 1)));
      expect(authentication.createdAt, isNotNull);
    });

    test('isExpired is false for a fresh token and true for an old one', () {
      final fresh = Authentication(
        accessToken: 'a',
        createdAt: DateTime.now(),
        expiresIn: const Duration(hours: 1),
      );
      final stale = Authentication(
        accessToken: 'a',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        expiresIn: const Duration(hours: 1),
      );

      expect(fresh.isExpired, isFalse);
      expect(stale.isExpired, isTrue);
    });
  });

  group('refresh on 401', () {
    test('refreshes once, retries with the new bearer token and succeeds',
        () async {
      final refreshed = Authentication(accessToken: 'new-token');
      var calls = 0;

      adapter.stubJsonApiError('GET', '/edge/anime',
          errors: [
            {'title': 'Unauthorized', 'status': '401'},
          ],
          statusCode: 401);

      final client = clientWith(
        adapter,
        onUnauthorized: () async {
          calls++;
          // The refresh callback is what re-arms the endpoint: the retried
          // request must find a successful answer.
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          return refreshed;
        },
      );

      final result = await client.get(method: 'anime');

      expect(calls, equals(1));
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests.first.header('Authorization'),
          equals('Bearer old-token'));
      expect(adapter.requests.last.header('Authorization'),
          equals('Bearer new-token'));
      expect(result, equals({'data': <dynamic>[]}));
    });

    test('without a refresh callback the 401 surfaces as an ApiException',
        () async {
      adapter.stubJsonApiError('GET', '/edge/anime',
          errors: [
            {'title': 'Unauthorized', 'status': '401'},
          ],
          statusCode: 401);
      final client = clientWith(adapter);

      await expectLater(
        client.get(method: 'anime'),
        throwsA(isA<ApiException>()),
      );

      expect(adapter.requests, hasLength(1));
    });

    test('a refresh returning null lets the original error through', () async {
      adapter.stubJsonApiError('GET', '/edge/anime',
          errors: [
            {'title': 'Unauthorized', 'status': '401'},
          ],
          statusCode: 401);
      final client = clientWith(adapter, onUnauthorized: () async => null);

      await expectLater(
        client.get(method: 'anime'),
        throwsA(isA<ApiException>()),
      );

      expect(adapter.requests, hasLength(1));
    });

    test('two 401s in a row do not loop', () async {
      adapter.stubJsonApiError('GET', '/edge/anime',
          errors: [
            {'title': 'Unauthorized', 'status': '401'},
          ],
          statusCode: 401);
      final client = clientWith(
        adapter,
        onUnauthorized: () async =>
            Authentication(accessToken: 'still-wrong'),
      );

      await expectLater(
        client.get(method: 'anime'),
        throwsA(isA<ApiException>()),
      );

      expect(adapter.requests, hasLength(2));
    });
  });
}
