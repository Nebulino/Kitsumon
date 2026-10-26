//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('Sorting', () {
    test('sorts ascending by default', () {
      expect(Sorting('userCount').format(), equals({'sort': 'userCount'}));
    });

    test('prefixes a minus sign when descending', () {
      expect(Sorting('userCount', descending: true).format(),
          equals({'sort': '-userCount'}));
    });

    test('joins multiple attributes with commas', () {
      expect(Sorting.multiple(['-userCount', 'canonicalTitle']).format(),
          equals({'sort': '-userCount,canonicalTitle'}));
    });

    test('a single attribute in multiple() has no separator', () {
      expect(Sorting.multiple(['slug']).format(), equals({'sort': 'slug'}));
    });

    test('multiple() with no attributes produces an empty value', () {
      expect(Sorting.multiple([]).format(), equals({'sort': ''}));
    });

    test('toString shows the direction', () {
      expect(Sorting('slug').toString(), equals('[Sorting] => slug'));
      expect(Sorting('slug', descending: true).toString(),
          equals('[Sorting] => -slug'));
    });
  });
}
