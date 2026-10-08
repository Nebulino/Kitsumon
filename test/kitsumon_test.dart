//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('Kitsumon Core Initialization', () {
    test('creates unauthenticated instance correctly', () {
      final kitsu = Kitsu.noAuth();
      expect(kitsu.authenticated, isFalse);
      expect(kitsu.authentication, isNull);
      expect(kitsu.client, isNotNull);

      final kitsumon = Kitsumon(kitsu: kitsu);
      expect(kitsumon.api, equals(kitsu));
      expect(Kitsumon.instance, equals(kitsumon));
      expect(kitsumon.media, isNotNull);
      expect(kitsumon.media.anime, isNotNull);
      expect(kitsumon.charactersAndPeople, isNotNull);
    });
  });
}
