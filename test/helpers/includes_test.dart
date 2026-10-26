//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('Includes', () {
    test('builds a comma-delimited include parameter', () {
      expect(Includes(['genres', 'categories']).build(),
          equals({'include': 'genres,categories'}));
    });

    test('keeps successive relationships written with a dot', () {
      expect(Includes(['animeCharacters.character']).build(),
          equals({'include': 'animeCharacters.character'}));
    });

    test('a single relationship has no separator', () {
      expect(Includes(['genres']).build(), equals({'include': 'genres'}));
    });

    test('an empty list produces an empty include value', () {
      expect(Includes([]).build(), equals({'include': ''}));
    });

    test('toString lists the relationships', () {
      expect(Includes(['genres', 'categories']).toString(),
          equals('[included] => genres,categories'));
    });
  });
}
