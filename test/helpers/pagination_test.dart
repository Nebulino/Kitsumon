//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('Pagination', () {
    test('formats nothing when empty', () {
      expect(Pagination().format(), isEmpty);
    });

    test('formats limit and offset under page[...]', () {
      expect(Pagination(limit: 15, offset: 30).format(),
          equals({'page[limit]': 15, 'page[offset]': 30}));
    });

    test('formats only the limit when there is no offset', () {
      expect(Pagination(limit: 5).format(), equals({'page[limit]': 5}));
    });

    test('formats only the offset when there is no limit', () {
      expect(Pagination(offset: 40).format(), equals({'page[offset]': 40}));
    });

    test('accepts the documented maximum limit of 20', () {
      expect(Pagination(limit: 20).format(), equals({'page[limit]': 20}));
    });

    test('rejects a limit above 20', () {
      expect(() => Pagination(limit: 21), throwsA(isA<KitsumonException>()));
    });

    test('rejects a negative limit', () {
      expect(() => Pagination(limit: -1), throwsA(isA<KitsumonException>()));
    });

    test('exposes limit and offset', () {
      final pagination = Pagination(limit: 10, offset: 20);
      expect(pagination.limit, equals(10));
      expect(pagination.offset, equals(20));
    });

    test('toString shows limit and offset', () {
      expect(Pagination(limit: 10, offset: 20).toString(),
          equals('[limit] => 10 | [offset] => 20'));
    });
  });
}
