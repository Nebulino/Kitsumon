//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

import '../support/fixtures.dart';

void main() {
  // One captured response of GET /edge/anime/1?include=animeCharacters,genres.
  late Map<String, dynamic> payload;

  setUp(() => payload = animeWithIncludeResponse());

  group('the captured payload', () {
    test('carries string-typed ids on the wire', () {
      final data = payload['data'] as Map<String, dynamic>;
      expect(data['id'], isA<String>());
      for (final resource in payload['included'] as List) {
        expect((resource as Map)['id'], isA<String>());
      }
    });
  });

  group('KitsuResponse / KitsuBaseObject parsing', () {
    test('AnimeResult is a KitsuResponse of a KitsuBaseObject', () {
      final result = AnimeResult.fromJson(payload);

      expect(result, isA<KitsuResponse>());
      expect(result.data, isA<KitsuBaseObject>());
      expect(result.included, everyElement(isA<KitsuBaseObject>()));
    });

    // Kitsu ids are strings on the wire; kitsumon normalises them to int
    // through KitsuValueNormalizer.stringToInt, so the *value* is preserved
    // and it is the Dart type that changes.
    test('ids are parsed from their string form and keep their value', () {
      final result = AnimeResult.fromJson(payload);

      expect(result.data!.id, isA<int>());
      expect(result.data!.id, equals(int.parse('1')));
      final characters = result.included!.cast<AnimeCharacter>();
      expect(characters.map((c) => c.id), equals([101, 102]));
    });

    test('type and self link are kept', () {
      final anime = AnimeResult.fromJson(payload).data!;

      expect(anime.type, equals('anime'));
      expect(anime.link, equals('https://kitsu.io/api/edge/anime/1'));
    });

    test('attributes are parsed', () {
      final attributes = AnimeResult.fromJson(payload).data!.attributes!;

      expect(attributes.slug, equals('cowboy-bebop'));
      expect(attributes.canonicalTitle, equals('Cowboy Bebop'));
      expect(attributes.subtype, equals(AnimeSubtype.TV));
      expect(attributes.status, equals(AnimeStatus.finished));
      expect(attributes.ageRating, equals(AgeRating.R));
      expect(attributes.episodeCount, equals(26));
    });

    test('null attributes in the payload stay null', () {
      final attributes = AnimeResult.fromJson(payload).data!.attributes!;

      expect(attributes.nextRelease, isNull);
      expect(attributes.tba, isNull);
    });

    test('included resources keep their order and drop unmodelled types', () {
      final included = AnimeResult.fromJson(payload).included!;

      // genres is not modelled yet, so only the two animeCharacters remain.
      expect(included.map((i) => i.type),
          equals(['animeCharacters', 'animeCharacters']));
    });

    test('a response without included has no included resources', () {
      payload.remove('included');

      expect(AnimeResult.fromJson(payload).included, isNull);
    });

    test('collection meta and pagination links are parsed', () {
      final results = AnimeResults.fromJson(animeCollectionResponse());

      expect(results.meta?.count, equals(1));
      expect(results.links?.first, contains('page[limit]=10'));
      expect(results.links?.next, contains('page[offset]=20'));
      expect(results.data!.single.id, equals(1));
    });
  });

  group('relationships', () {
    late AnimeCharacter character;

    setUp(() {
      character =
          AnimeResult.fromJson(payload).included!.first as AnimeCharacter;
    });

    test('are parsed on the included anime character', () {
      final relationships = character.relationships!;

      expect(relationships.anime, isA<AnimeRelation>());
      expect(relationships.character, isA<CharacterRelation>());
      expect(relationships.castings, isA<CastingsRelation>());
    });

    test('keep their links', () {
      final links = character.relationships!.character!.links!;

      expect(links, isA<KitsuRelationshipLinks>());
      expect(links.self,
          equals('https://kitsu.io/api/edge/anime-characters/101/relationships/character'));
      expect(links.related,
          equals('https://kitsu.io/api/edge/anime-characters/101/character'));
    });

    test('keep their linkage data, with ids parsed from strings', () {
      final relationships = character.relationships!;

      expect(relationships.anime!.data, isA<KitsuBaseRelationData>());
      expect(relationships.anime!.data!.type, equals('anime'));
      expect(relationships.anime!.data!.id, equals(1));
      expect(relationships.character!.data!.type, equals('characters'));
      expect(relationships.character!.data!.id, equals(1));
      expect(relationships.castings!.data!.map((d) => d.type),
          equals(['castings', 'castings']));
      expect(relationships.castings!.data!.map((d) => d.id),
          equals([5001, 5002]));
    });

    test('survive serialization', () {
      final json = jsonDecode(jsonEncode(character.toJson())) as Map;
      final relationships = json['relationships'] as Map;

      expect(relationships.keys, containsAll(['anime', 'character', 'castings']));
      expect((relationships['character'] as Map)['links'], {
        'self':
            'https://kitsu.io/api/edge/anime-characters/101/relationships/character',
        'related':
            'https://kitsu.io/api/edge/anime-characters/101/character',
      });
      expect((relationships['character'] as Map)['data'],
          equals({'type': 'characters', 'id': 1}));
      expect((relationships['castings'] as Map)['data'], [
        {'type': 'castings', 'id': 5001},
        {'type': 'castings', 'id': 5002},
      ]);
    });

    test('a relationship without data keeps only its links', () {
      final relation = AnimeRelation.fromJson({
        'links': {'self': 's', 'related': 'r'},
      });

      expect(relation.data, isNull);
      expect(relation.links?.self, equals('s'));
      expect(relation.links?.related, equals('r'));
    });
  });

  group('serialization', () {
    test('toJson omits null members and keeps the parsed values', () {
      final json = jsonDecode(jsonEncode(AnimeResult.fromJson(payload).toJson()))
          as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final attributes = data['attributes'] as Map<String, dynamic>;

      expect(data['type'], equals('anime'));
      expect(data['id'], equals(1));
      expect(attributes['slug'], equals('cowboy-bebop'));
      expect(attributes.containsKey('nextRelease'), isFalse);
      expect(attributes.containsKey('tba'), isFalse);
      expect((json['included'] as List), hasLength(2));
    });

    test('Authentication parses and serializes the OAuth token response', () {
      final authentication = Authentication.fromJson({
        'access_token': 'abc',
        'token_type': 'bearer',
        'expires_in': 2592000,
        'refresh_token': 'def',
        'scope': 'public',
        'created_at': 1700000000,
      });

      expect(authentication.accessToken, equals('abc'));
      expect(authentication.expiresIn, equals(const Duration(seconds: 2592000)));
      expect(authentication.refreshToken, equals('def'));
      expect(authentication.scope, equals('public'));
      expect(authentication.createdAt,
          equals(DateTime.fromMillisecondsSinceEpoch(1700000000000)));

      final json = authentication.toJson();
      expect(json['access_token'], equals('abc'));
      expect(json['refresh_token'], equals('def'));
      expect(json['scope'], equals('public'));
    });

    test('Authentication tolerates a response without optional members', () {
      final authentication = Authentication.fromJson({'access_token': 'abc'});

      expect(authentication.accessToken, equals('abc'));
      expect(authentication.expiresIn, isNull);
      expect(authentication.createdAt, isNull);
      expect(authentication.toJson(), equals({'access_token': 'abc'}));
    });
  });
}
