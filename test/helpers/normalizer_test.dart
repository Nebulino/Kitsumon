//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:kitsumon/src/helpers/inclusion_extractor.dart';
import 'package:kitsumon/src/helpers/kitsu_value_normalizer.dart';
import 'package:test/test.dart';

import '../support/fixtures.dart';

void main() {
  group('KitsuValueNormalizer', () {
    group('secondsDurationParser', () {
      test('turns whole seconds into a Duration', () {
        expect(KitsuValueNormalizer.secondsDurationParser(3600),
            equals(const Duration(hours: 1)));
      });

      test('truncates fractional seconds', () {
        expect(KitsuValueNormalizer.secondsDurationParser(1.9),
            equals(const Duration(seconds: 1)));
      });

      test('returns null for null and for non-numbers', () {
        expect(KitsuValueNormalizer.secondsDurationParser(null), isNull);
        expect(KitsuValueNormalizer.secondsDurationParser('60'), isNull);
      });

      test('the PascalCase alias behaves the same', () {
        expect(KitsuValueNormalizer.SecondsDurationParser(30),
            equals(const Duration(seconds: 30)));
      });
    });

    group('unixTimeDateTimeParser', () {
      test('turns unix seconds into a DateTime', () {
        expect(KitsuValueNormalizer.unixTimeDateTimeParser(1700000000),
            equals(DateTime.fromMillisecondsSinceEpoch(1700000000000)));
      });

      test('accepts a double', () {
        expect(KitsuValueNormalizer.unixTimeDateTimeParser(1700000000.0),
            equals(DateTime.fromMillisecondsSinceEpoch(1700000000000)));
      });

      test('returns null for null and for non-numbers', () {
        expect(KitsuValueNormalizer.unixTimeDateTimeParser(null), isNull);
        expect(KitsuValueNormalizer.unixTimeDateTimeParser('1700000000'), isNull);
      });

      test('the PascalCase alias behaves the same', () {
        expect(KitsuValueNormalizer.UnixTimeDateTimeParser(0),
            equals(DateTime.fromMillisecondsSinceEpoch(0)));
      });
    });

    group('apiSelfLinkExtractor', () {
      test('extracts the self link of a links object', () {
        expect(
          KitsuValueNormalizer.apiSelfLinkExtractor(
              {'self': 'https://kitsu.io/api/edge/anime/1'}),
          equals('https://kitsu.io/api/edge/anime/1'),
        );
      });

      test('returns null when there is no self link', () {
        expect(
          KitsuValueNormalizer.apiSelfLinkExtractor(
              {'related': 'https://kitsu.io/api/edge/anime/1/genres'}),
          isNull,
        );
      });

      test('returns null for null', () {
        expect(KitsuValueNormalizer.apiSelfLinkExtractor(null), isNull);
      });

      test('throws a KitsumonException for anything else', () {
        expect(() => KitsuValueNormalizer.apiSelfLinkExtractor('https://x'),
            throwsA(isA<KitsumonException>()));
      });

      test('the PascalCase alias behaves the same', () {
        expect(KitsuValueNormalizer.ApiSelfLinkExtractor({'self': 'a'}),
            equals('a'));
      });
    });

    group('stringToInt', () {
      test('parses the string-typed ids Kitsu sends', () {
        expect(KitsuValueNormalizer.stringToInt('42'), equals(42));
      });

      test('passes integers through and truncates other numbers', () {
        expect(KitsuValueNormalizer.stringToInt(42), equals(42));
        expect(KitsuValueNormalizer.stringToInt(42.9), equals(42));
      });

      test('returns null for null and for unparsable strings', () {
        expect(KitsuValueNormalizer.stringToInt(null), isNull);
        expect(KitsuValueNormalizer.stringToInt('abc'), isNull);
      });

      test('throws a KitsumonException for unsupported types', () {
        expect(() => KitsuValueNormalizer.stringToInt(true),
            throwsA(isA<KitsumonException>()));
      });

      test('the PascalCase alias behaves the same', () {
        expect(KitsuValueNormalizer.StringToInt('7'), equals(7));
      });
    });
  });

  group('inclusionExtractor', () {
    test('returns null for a null inclusion', () {
      expect(inclusionExtractor(null), isNull);
    });

    test('returns null for an unsupported inclusion shape', () {
      expect(inclusionExtractor('anime'), isNull);
      expect(inclusionExtractor(42), isNull);
    });

    test('an empty list gives an empty list', () {
      expect(inclusionExtractor(<dynamic>[]), isEmpty);
    });

    test('builds typed objects from included resources of several types', () {
      final included = animeWithIncludeResponse()['included'] as List;

      final extracted = inclusionExtractor(included) as List;

      // The genres resource is of a type that is not modelled yet and is
      // skipped; the two animeCharacters survive in order.
      expect(extracted, hasLength(2));
      expect(extracted, everyElement(isA<AnimeCharacter>()));
      expect(extracted.map((e) => (e as AnimeCharacter).id), equals([101, 102]));
      expect(extracted.map((e) => (e as AnimeCharacter).attributes?.role),
          equals([AnimeCharacterRole.main, AnimeCharacterRole.supporting]));
    });

    test('recognises anime, animeCharacters and characters', () {
      final extracted = inclusionExtractor([
        {'type': 'anime', 'id': '1'},
        {'type': 'animeCharacters', 'id': '2'},
        {'type': 'characters', 'id': '3'},
      ]) as List;

      expect(extracted[0], isA<Anime>());
      expect(extracted[1], isA<AnimeCharacter>());
      expect(extracted[2], isA<AnimeCharacter>());
      expect(extracted.map((e) => (e as KitsuBaseObject).id), equals([1, 2, 3]));
    });

    test('skips entries that are not objects and unknown types', () {
      final extracted = inclusionExtractor([
        'garbage',
        42,
        null,
        {'type': 'streamingLinks', 'id': '1'},
        {'id': '9'},
        {'type': 'anime', 'id': '5'},
      ]) as List;

      expect(extracted, hasLength(1));
      expect((extracted.single as Anime).id, equals(5));
    });

    test('handles null attributes and relationships', () {
      final extracted = inclusionExtractor([
        {
          'type': 'animeCharacters',
          'id': '77',
          'attributes': null,
          'relationships': null,
        },
      ]) as List;

      final character = extracted.single as AnimeCharacter;
      expect(character.id, equals(77));
      expect(character.attributes, isNull);
      expect(character.relationships, isNull);
    });

    test('accepts numeric as well as string-typed ids', () {
      final extracted = inclusionExtractor([
        {'type': 'anime', 'id': 3},
        {'type': 'anime', 'id': '4'},
      ]) as List;

      expect(extracted.map((e) => (e as Anime).id), equals([3, 4]));
    });

    test('a single object is built directly', () {
      final result = inclusionExtractor(animeCharacterResource(id: '55'));

      expect(result, isA<AnimeCharacter>());
      expect((result as AnimeCharacter).id, equals(55));
    });

    test('a single object of an unknown type gives null', () {
      expect(inclusionExtractor(genreResource()), isNull);
    });

    test('a map that is not typed <String, dynamic> is accepted', () {
      final result = inclusionExtractor(<dynamic, dynamic>{
        'type': 'anime',
        'id': '12',
      });

      expect((result as Anime).id, equals(12));
    });
  });
}
