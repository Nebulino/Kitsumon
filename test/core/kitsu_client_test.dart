//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fake_http_client.dart';

typedef _ClientBuilder = KitsuClient Function(
  FakeHttpClientAdapter adapter, {
  Authentication? authentication,
});

Matcher _isTimeoutFailure() => isA<DioException>().having(
      (e) => e.error,
      'error',
      isA<KitsumonException>().having(
        (e) => e.description,
        'description',
        'Timeout Exception.',
      ),
    );

void main() {
  // The behaviour every KitsuClient must show, whether it builds its own Dio
  // or wraps one injected by the caller. Running the same contract on both is
  // what closes the "injected Dio loses its interceptors" regression.
  final builders = <String, _ClientBuilder>{
    'built-in Dio': (adapter, {authentication}) =>
        createFakeKitsuClient(adapter, authentication: authentication),
    'injected Dio': (adapter, {authentication}) =>
        createInjectedFakeKitsuClient(adapter, authentication: authentication),
  };

  for (final MapEntry(key: label, value: build) in builders.entries) {
    group('KitsuClient ($label)', () {
      late FakeHttpClientAdapter adapter;

      setUp(() => adapter = FakeHttpClientAdapter());

      group('GET', () {
        test('requests /edge/<method> with the given parameters', () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(adapter);

          final response = await client.get(
            method: 'anime',
            parameters: {'filter[text]': 'bebop', 'page[limit]': 5},
          );

          expect(adapter.requests, hasLength(1));
          final request = adapter.lastRequest;
          expect(request.method, equals('GET'));
          expect(request.path, equals('/edge/anime'));
          expect(request.uri.origin, equals('https://kitsu.io'));
          expect(request.uri.path, equals('/api/edge/anime'));
          expect(request.queryParameters,
              equals({'filter[text]': 'bebop', 'page[limit]': 5}));
          expect(request.uri.queryParameters,
              equals({'filter[text]': 'bebop', 'page[limit]': '5'}));
          expect(response, equals({'data': <dynamic>[]}));
        });

        test('keeps nested method paths', () async {
          adapter.stub('GET', '/edge/anime/1', body: {'data': null});
          final client = build(adapter);

          await client.get(method: 'anime/1');

          expect(adapter.lastRequest.path, equals('/edge/anime/1'));
          expect(adapter.lastRequest.queryParameters, isEmpty);
        });

        test('strips null parameters before the request leaves', () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(adapter);

          await client.get(
            method: 'anime',
            parameters: {'filter[slug]': null, 'include': 'genres', 'x': null},
          );

          expect(adapter.lastRequest.queryParameters,
              equals({'include': 'genres'}));
          expect(adapter.lastRequest.uri.query, equals('include=genres'));
        });
      });

      group('POST', () {
        test('sends the body and strips null members', () async {
          adapter.stub('POST', '/edge/library-entries',
              body: {'data': {'id': '9'}}, statusCode: 201);
          final client = build(adapter);

          final response = await client.post(
            method: 'library-entries',
            body: {'status': 'current', 'rating': null, 'progress': 3},
          );

          final request = adapter.lastRequest;
          expect(request.method, equals('POST'));
          expect(request.path, equals('/edge/library-entries'));
          expect(request.data, equals({'status': 'current', 'progress': 3}));
          expect(response, equals({'data': {'id': '9'}}));
        });

        test('sends an empty object when there is no body', () async {
          adapter.stub('POST', '/edge/library-entries', body: <String, dynamic>{});
          final client = build(adapter);

          await client.post(method: 'library-entries');

          expect(adapter.lastRequest.data, equals(<String, dynamic>{}));
        });

        test('auth() posts the credentials to /oauth/token', () async {
          adapter.stub('POST', '/oauth/token', body: {'access_token': 'abc'});
          final client = build(adapter);

          final response = await client.auth(
            body: {'grant_type': 'password', 'username': 'u', 'password': 'p'},
          );

          expect(adapter.lastRequest.method, equals('POST'));
          expect(adapter.lastRequest.path, equals('/oauth/token'));
          expect(
            adapter.lastRequest.data,
            equals({'grant_type': 'password', 'username': 'u', 'password': 'p'}),
          );
          expect(response, equals({'access_token': 'abc'}));
        });
      });

      group('PATCH and DELETE', () {
        test('patch() sends the body to /edge/<method> and returns the data',
            () async {
          adapter.stub('PATCH', '/edge/library-entries/42',
              body: {'data': {'id': '42', 'type': 'libraryEntries'}});
          final client = build(adapter);

          final response = await client.patch(
            method: 'library-entries/42',
            body: {'progress': 13},
          );

          expect(adapter.lastRequest.method, equals('PATCH'));
          expect(adapter.lastRequest.path, equals('/edge/library-entries/42'));
          expect(adapter.lastRequest.data, equals({'progress': 13}));
          expect(response, equals({'data': {'id': '42', 'type': 'libraryEntries'}}));
        });

        test('delete() sends a DELETE to /edge/<method>', () async {
          adapter.stub('DELETE', '/edge/library-entries/42',
              body: <String, dynamic>{}, statusCode: 204);
          final client = build(adapter);

          await client.delete(method: 'library-entries/42');

          expect(adapter.lastRequest.method, equals('DELETE'));
          expect(adapter.lastRequest.path, equals('/edge/library-entries/42'));
        });
      });

      group('headers', () {
        test('sends the JSON:API Accept header', () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(adapter);

          await client.get(method: 'anime');

          expect(adapter.lastRequest.header('Accept'),
              equals('application/vnd.api+json'));
        });

        test('sends the JSON:API Content-Type header with a body', () async {
          adapter.stub('POST', '/edge/library-entries', body: <String, dynamic>{});
          final client = build(adapter);

          await client.post(method: 'library-entries', body: {'a': 1});

          expect(adapter.lastRequest.header('Content-Type'),
              equals('application/vnd.api+json'));
        });

        test('sends no Authorization header when not authenticated',
            () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(adapter);

          await client.get(method: 'anime');

          expect(adapter.lastRequest.header('Authorization'), isNull);
        });

        test('sends no Authorization header when the token is missing',
            () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(adapter, authentication: Authentication());

          await client.get(method: 'anime');

          expect(adapter.lastRequest.header('Authorization'), isNull);
        });

        test('sends Authorization: Bearer <token> when authenticated',
            () async {
          adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
          final client = build(
            adapter,
            authentication: Authentication(accessToken: 'secret-token'),
          );

          await client.get(method: 'anime');

          expect(adapter.lastRequest.header('Authorization'),
              equals('Bearer secret-token'));
        });
      });

      group('timeouts', () {
        for (final type in [
          DioExceptionType.connectionTimeout,
          DioExceptionType.receiveTimeout,
        ]) {
          test('$type surfaces as a KitsumonException', () async {
            adapter.stubFailure('GET', '/edge/anime', type: type);
            final client = build(adapter);

            await expectLater(
                client.get(method: 'anime'), throwsA(_isTimeoutFailure()));
          });
        }

        test('other transport failures pass through untouched', () async {
          adapter.stubFailure('GET', '/edge/anime',
              type: DioExceptionType.connectionError);
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime'),
            throwsA(isA<DioException>()
                .having((e) => e.type, 'type',
                    DioExceptionType.connectionError)
                .having((e) => e.error, 'error', isNot(isA<KitsumonException>()))),
          );
        });
      });

      group('JSON:API errors', () {
        test('errors[] becomes an ApiException with title/detail/code/status',
            () async {
          adapter.stubJsonApiError(
            'GET',
            '/edge/anime',
            statusCode: 400,
            errors: [
              {
                'title': 'Filter not allowed',
                'detail': 'bogus is not allowed.',
                'code': '102',
                'status': '400',
              },
            ],
          );
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime'),
            throwsA(isA<ApiException>()
                .having((e) => e.title, 'title', 'Filter not allowed')
                .having((e) => e.detail, 'detail', 'bogus is not allowed.')
                .having((e) => e.code, 'code', 102)
                .having((e) => e.status, 'status', 400)
                .having((e) => e.response?.statusCode, 'response.statusCode',
                    400)
                .having((e) => e.requestOptions.path, 'requestOptions.path',
                    '/edge/anime')),
          );
        });

        test('uses the first entry of errors[] and a non-400 status',
            () async {
          adapter.stubJsonApiError(
            'GET',
            '/edge/anime/999999',
            statusCode: 404,
            errors: [
              {
                'title': 'The requested record was not found',
                'detail': 'No such record.',
                'code': '404',
                'status': '404',
              },
              {'title': 'Second', 'detail': 'ignored', 'status': '500'},
            ],
          );
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime/999999'),
            throwsA(isA<ApiException>()
                .having((e) => e.title, 'title',
                    'The requested record was not found')
                .having((e) => e.status, 'status', 404)),
          );
        });

        test('missing members fall back to empty/default values', () async {
          adapter.stubJsonApiError('GET', '/edge/anime',
              statusCode: 422, errors: [<String, dynamic>{}]);
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime'),
            throwsA(isA<ApiException>()
                .having((e) => e.title, 'title', '')
                .having((e) => e.detail, 'detail', '')
                .having((e) => e.code, 'code', 0)
                .having((e) => e.status, 'status', 400)),
          );
        });

        test('also maps errors raised by POST', () async {
          adapter.stubJsonApiError(
            'POST',
            '/oauth/token',
            statusCode: 401,
            errors: [
              {
                'title': 'Unauthorized',
                'detail': 'invalid_grant',
                'status': '401',
              },
            ],
          );
          final client = build(adapter);

          await expectLater(
            client.auth(body: {'grant_type': 'password'}),
            throwsA(isA<ApiException>()
                .having((e) => e.title, 'title', 'Unauthorized')
                .having((e) => e.status, 'status', 401)),
          );
        });

        test('a bad response without errors[] stays a plain DioException',
            () async {
          adapter.stub('GET', '/edge/anime',
              body: 'Internal Server Error',
              statusCode: 500,
              headers: {
                Headers.contentTypeHeader: ['text/plain'],
              });
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime'),
            throwsA(isA<DioException>()
                .having((e) => e, 'is not ApiException',
                    isNot(isA<ApiException>()))
                .having((e) => e.type, 'type', DioExceptionType.badResponse)
                .having((e) => e.response?.statusCode, 'status', 500)),
          );
        });

        test('an empty errors[] stays a plain DioException', () async {
          adapter.stubJsonApiError('GET', '/edge/anime',
              statusCode: 400, errors: []);
          final client = build(adapter);

          await expectLater(
            client.get(method: 'anime'),
            throwsA(isA<DioException>().having(
                (e) => e, 'is not ApiException', isNot(isA<ApiException>()))),
          );
        });
      });

      test('an unstubbed request never reaches the network', () async {
        final client = build(adapter);

        await expectLater(
          client.get(method: 'anime'),
          throwsA(isA<DioException>().having(
              (e) => e.error, 'error', isA<UnstubbedRequestError>())),
        );
        expect(adapter.requests, hasLength(1));
      });
    });
  }

  group('KitsuClient built-in Dio defaults', () {
    test('uses the Kitsu base URL and JSON:API headers', () {
      final client = KitsuClient();
      final options = client.dio.options;

      expect(options.baseUrl, equals('https://kitsu.io/api'));
      expect(options.headers['Accept'], equals('application/vnd.api+json'));
      expect(options.contentType, equals('application/vnd.api+json'));
      expect(options.responseType, equals(ResponseType.json));
      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('puts the bearer token in the default headers', () {
      final client = KitsuClient(
        authentication: Authentication(accessToken: 'tok'),
      );

      expect(client.dio.options.headers['Authorization'], equals('Bearer tok'));
    });
  });

  group('KitsuClient with an injected Dio', () {
    late FakeHttpClientAdapter adapter;

    setUp(() => adapter = FakeHttpClientAdapter());

    test('uses the very Dio it was given', () {
      final dio = Dio();
      expect(KitsuClient(dio: dio).dio, same(dio));
    });

    test('fills in only what the caller left out', () async {
      adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
      final dio = Dio();
      final client = createInjectedFakeKitsuClient(
        adapter,
        dio: dio,
        authentication: Authentication(accessToken: 'tok'),
      );

      await client.get(method: 'anime');

      expect(dio.options.baseUrl, equals('https://kitsu.io/api'));
      final request = adapter.lastRequest;
      expect(request.uri.toString(), startsWith('https://kitsu.io/api/edge/anime'));
      expect(request.header('Accept'), equals('application/vnd.api+json'));
      expect(request.header('Authorization'), equals('Bearer tok'));
    });

    test('never overwrites what the caller configured', () async {
      adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
      final dio = Dio(BaseOptions(
        baseUrl: 'https://mirror.example/api',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer caller-token',
        },
        contentType: 'application/json',
      ));
      final client = createInjectedFakeKitsuClient(
        adapter,
        dio: dio,
        authentication: Authentication(accessToken: 'other-token'),
      );

      await client.get(method: 'anime');

      final request = adapter.lastRequest;
      expect(request.uri.host, equals('mirror.example'));
      expect(request.header('Accept'), equals('application/json'));
      expect(request.header('Content-Type'), equals('application/json'));
      expect(request.header('Authorization'), equals('Bearer caller-token'));
    });

    test('keeps working alongside interceptors the caller registered',
        () async {
      adapter.stub('GET', '/edge/anime', body: {'data': <dynamic>[]});
      final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))
        ..interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['X-Caller'] = 'yes';
            handler.next(options);
          },
        ));
      final client = createInjectedFakeKitsuClient(adapter, dio: dio);

      await client.get(method: 'anime', parameters: {'a': null, 'b': 1});

      expect(adapter.lastRequest.header('X-Caller'), equals('yes'));
      expect(adapter.lastRequest.queryParameters, equals({'b': 1}));
    });

    test('the existing mock style (an interceptor that resolves) still works',
        () async {
      late RequestOptions seen;
      final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))
        ..interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            seen = options;
            handler.resolve(Response(
                requestOptions: options, data: {'data': 1}, statusCode: 200));
          },
        ));
      final client = KitsuClient(dio: dio);

      final response = await client.get(method: 'anime');

      expect(seen.path, equals('/edge/anime'));
      expect(response, equals({'data': 1}));
    });
  });

  group('KitsuClient interceptor registration', () {
    // Choice: registration is IDEMPOTENT. The interceptor is stateless (the
    // bearer token lives in the Dio options, not in the interceptor), so a
    // second KitsuClient around the same Dio simply finds the interceptor
    // already registered and does not add another one.
    test('is idempotent when wrapping the same Dio twice', () async {
      final adapter = FakeHttpClientAdapter()
        ..stubJsonApiError('GET', '/edge/anime', errors: [
          {'title': 'T', 'detail': 'D', 'code': '1', 'status': '400'},
        ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))
        ..httpClientAdapter = adapter;
      final baseline = dio.interceptors.length;

      final first = KitsuClient(dio: dio);
      final afterFirst = dio.interceptors.length;
      final second = KitsuClient(
        dio: dio,
        authentication: Authentication(accessToken: 'tok'),
      );

      expect(afterFirst, equals(baseline + 1));
      expect(dio.interceptors.length, equals(afterFirst));
      expect(first.dio, same(second.dio));

      // Error mapping happened once: a double registration would have fed the
      // already-mapped ApiException through the mapper again.
      await expectLater(
        second.get(method: 'anime'),
        throwsA(isA<ApiException>().having((e) => e.title, 'title', 'T')),
      );
    });

    test('a built-in Dio carries exactly one Kitsu interceptor', () {
      final baseline = Dio().interceptors.length;
      expect(KitsuClient().dio.interceptors.length, equals(baseline + 1));
    });

    test('stripping nulls is applied once per request', () async {
      final adapter = FakeHttpClientAdapter()
        ..stub('POST', '/edge/library-entries', body: <String, dynamic>{});
      final dio = Dio(BaseOptions(baseUrl: 'https://kitsu.io/api'))
        ..httpClientAdapter = adapter;
      KitsuClient(dio: dio);
      final client = KitsuClient(dio: dio);

      await client.post(method: 'library-entries', body: {'a': 1, 'b': null});

      expect(adapter.requests, hasLength(1));
      expect(adapter.lastRequest.data, equals({'a': 1}));
    });
  });

  group('KitsuClient proxy', () {
    test('without a proxy the default adapter is left alone', () {
      final adapter = KitsuClient().dio.httpClientAdapter;

      expect(adapter, isA<IOHttpClientAdapter>());
      expect((adapter as IOHttpClientAdapter).createHttpClient, isNull);
    });

    test('an empty proxy is ignored', () {
      final adapter = KitsuClient(proxy: '').dio.httpClientAdapter;

      expect((adapter as IOHttpClientAdapter).createHttpClient, isNull);
    });

    test('a proxy installs a custom HttpClient factory', () {
      final adapter =
          KitsuClient(proxy: 'localhost:8888').dio.httpClientAdapter;

      expect(adapter, isA<IOHttpClientAdapter>());
      final factory = (adapter as IOHttpClientAdapter).createHttpClient;
      expect(factory, isNotNull);
      final httpClient = factory!();
      addTearDown(httpClient.close);
      expect(httpClient, isNotNull);
    });

    test('a proxy does not change interceptors or headers', () {
      final client = KitsuClient(proxy: 'localhost:8888');

      expect(client.dio.options.baseUrl, equals('https://kitsu.io/api'));
      expect(client.dio.interceptors.length,
          equals(Dio().interceptors.length + 1));
    });

    test('is not applied to an injected Dio, whose adapter is the '
        'caller\'s business', () {
      final dio = Dio();
      KitsuClient(dio: dio, proxy: 'localhost:8888');

      expect((dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient,
          isNull);
    });
  });
}
