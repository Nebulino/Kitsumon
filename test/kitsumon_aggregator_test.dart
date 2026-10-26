//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import 'support/fake_http_client.dart';
import 'support/fixtures.dart';

void main() {
  group('Kitsumon aggregator entry points', () {
    late FakeHttpClientAdapter adapter;
    final authentication = Authentication(accessToken: 'session-token');

    setUp(() => adapter = FakeHttpClientAdapter());

    // The three ways a session is obtained:
    //  - unauthenticated: Kitsu.noAuth()
    //  - custom client:   Kitsu.withClient(client)
    //  - authenticated:   Kitsu.withClient(client, authentication), which is
    //    what Kitsu.authenticate() returns once the password grant succeeded
    //    (that call itself needs the network, so it is not exercised here).
    final entryPoints = <String, Kitsu Function(FakeHttpClientAdapter)>{
      'noAuth': (_) => Kitsu.noAuth(),
      'withClient': (adapter) => Kitsu.withClient(createFakeKitsuClient(adapter)),
      'authenticated': (adapter) => Kitsu.withClient(
            createFakeKitsuClient(adapter, authentication: authentication),
            authentication,
          ),
    };

    for (final entry in entryPoints.entries) {
      test('${entry.key} exposes the same modules', () {
        final kitsu = entry.value(adapter);
        final kitsumon = Kitsumon(kitsu: kitsu);

        expect(kitsumon.api, same(kitsu));
        expect(kitsumon.media, isA<Media>());
        expect(kitsumon.media.anime, isA<AnimeMethods>());
        expect(kitsumon.media.anime.api, same(kitsu));
        expect(kitsumon.media.anime.methodRadix, equals('anime'));
        expect(kitsumon.charactersAndPeople, isA<CharactersAndPeople>());
        expect(kitsumon.charactersAndPeople.animeCharacters,
            isA<AnimeCharactersMethods>());
        expect(kitsumon.charactersAndPeople.animeCharacters.api, same(kitsu));
        expect(kitsumon.charactersAndPeople.animeCharacters.methodRadix,
            equals('anime-characters'));
        expect(Kitsumon.instance, same(kitsumon));
      });
    }

    test('authenticated reflects the session', () {
      expect(Kitsu.noAuth().authenticated, isFalse);
      expect(Kitsu.noAuth().authentication, isNull);

      final plain = Kitsu.withClient(createFakeKitsuClient(adapter));
      expect(plain.authenticated, isFalse);
      expect(plain.authentication, isNull);

      final session = Kitsu.withClient(
        createFakeKitsuClient(adapter, authentication: authentication),
        authentication,
      );
      expect(session.authenticated, isTrue);
      expect(session.authentication, same(authentication));
    });

    test('withClient keeps the very client it was given', () {
      final client = createFakeKitsuClient(adapter);

      expect(Kitsu.withClient(client).client, same(client));
    });

    test('every entry point serves requests through its client', () async {
      adapter.stub('GET', '/edge/anime/1', body: {'data': animeResource()});
      adapter.stub('GET', '/edge/anime-characters/101',
          body: {'data': animeCharacterResource()});

      for (final entry in entryPoints.entries) {
        if (entry.key == 'noAuth') continue; // its own client is not faked
        final kitsumon = Kitsumon(kitsu: entry.value(adapter));

        final anime = await kitsumon.media.anime.fetchResource(1);
        final character =
            await kitsumon.charactersAndPeople.animeCharacters.fetchResource(101);

        expect(anime.data?.attributes?.slug, equals('cowboy-bebop'),
            reason: entry.key);
        expect(character.data?.attributes?.role, equals(AnimeCharacterRole.main),
            reason: entry.key);
      }
    });

    test('the authenticated session sends its token, the others do not',
        () async {
      adapter.stub('GET', '/edge/anime/1', body: {'data': animeResource()});

      await Kitsumon(
        kitsu: Kitsu.withClient(createFakeKitsuClient(adapter)),
      ).media.anime.fetchResource(1);
      expect(adapter.lastRequest.header('Authorization'), isNull);

      await Kitsumon(
        kitsu: Kitsu.withClient(
          createFakeKitsuClient(adapter, authentication: authentication),
          authentication,
        ),
      ).media.anime.fetchResource(1);
      expect(adapter.lastRequest.header('Authorization'),
          equals('Bearer session-token'));
    });
  });
}
