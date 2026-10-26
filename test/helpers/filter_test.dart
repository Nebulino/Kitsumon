//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('Filter', () {
    test('formats a scalar value under filter[<attribute>]', () {
      expect(Filter('text', 'bebop').format(), equals({'filter[text]': 'bebop'}));
    });

    test('keeps non-string scalars as they are', () {
      expect(Filter('seasonYear', 1998).format(),
          equals({'filter[seasonYear]': 1998}));
      expect(Filter('nsfw', false).format(), equals({'filter[nsfw]': false}));
    });

    test('joins a list with commas', () {
      expect(Filter('genres', ['action', 'sci-fi']).format(),
          equals({'filter[genres]': 'action,sci-fi'}));
      expect(Filter('id', [1, 2, 3]).format(), equals({'filter[id]': '1,2,3'}));
    });

    test('a single-element list has no separator', () {
      expect(Filter('genres', ['action']).format(),
          equals({'filter[genres]': 'action'}));
    });

    test('an empty list produces an empty value', () {
      expect(Filter('genres', <String>[]).format(), equals({'filter[genres]': ''}));
    });

    test('a null value produces no parameter at all', () {
      expect(Filter('text', null).format(), isNull);
    });

    test('toString shows attribute and value', () {
      expect(Filter('text', 'bebop').toString(), equals('[text] => bebop'));
    });
  });
}
