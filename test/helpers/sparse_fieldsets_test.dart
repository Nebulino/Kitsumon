//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('SparseFieldSets', () {
    test('builds fields[<object>] with comma-joined fields', () {
      expect(SparseFieldSets('anime', ['slug', 'canonicalTitle']).build(),
          equals({'fields[anime]': 'slug,canonicalTitle'}));
    });

    test('a single field has no separator', () {
      expect(SparseFieldSets('anime', ['slug']).build(),
          equals({'fields[anime]': 'slug'}));
    });

    test('the object name becomes part of the key', () {
      expect(SparseFieldSets('genres', ['name']).build(),
          equals({'fields[genres]': 'name'}));
    });

    test('no fields produce an empty value', () {
      expect(SparseFieldSets('anime', []).build(), equals({'fields[anime]': ''}));
    });

    test('toString shows object and fields', () {
      expect(SparseFieldSets('anime', ['slug', 'status']).toString(),
          equals('[SparseFieldSets: anime] => slug,status'));
    });
  });
}
