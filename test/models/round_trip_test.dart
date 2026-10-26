//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';
import 'package:test/test.dart';

void main() {
  group('links round-trip', () {
    test('toJson writes the object form fromJson reads back', () {
      final anime = Anime(
        id: 1,
        type: 'anime',
        link: 'https://kitsu.io/api/edge/anime/1',
      );

      final json = anime.toJson();

      expect(json['links'], equals({'self': 'https://kitsu.io/api/edge/anime/1'}));
      expect(Anime.fromJson(json).link, equals(anime.link));
    });

    test('a resource without links keeps them null in both directions', () {
      final anime = Anime(id: 2, type: 'anime');

      expect(anime.toJson().containsKey('links'), isFalse);
      expect(Anime.fromJson(anime.toJson()).link, isNull);
    });
  });

  group('relationships are parsed, not dropped', () {
    Map<String, dynamic> payload(Map<String, dynamic> relationships) => {
          'id': '1',
          'type': 'anime',
          'attributes': {'slug': 'cowboy-bebop'},
          'relationships': relationships,
        };

    test('a media resource keeps its relationships', () {
      final anime = Anime.fromJson(payload({
        'genres': {
          'links': {
            'self': 'https://kitsu.io/api/edge/anime/1/relationships/genres',
            'related': 'https://kitsu.io/api/edge/anime/1/genres',
          },
        },
        'episodes': {
          'links': {
            'self': 'https://kitsu.io/api/edge/anime/1/relationships/episodes',
          },
        },
      }));

      expect(anime.relationships, isNotNull);
      expect(anime.relationships!.genres, isA<KitsuRelation>());
      expect(anime.relationships!.genres!.links!.related,
          contains('/anime/1/genres'));
      expect(anime.relationships!.episodes, isA<KitsuRelation>());
    });

    test('an unknown relationship does not throw', () {
      final anime = Anime.fromJson(payload({
        'somethingNew': {
          'links': {'self': 'https://kitsu.io/api/edge/anime/1/relationships/x'},
        },
      }));

      expect(anime.attributes!.slug, equals('cowboy-bebop'));
      expect(anime.relationships, isNotNull);
    });

    test('no relationships stays null', () {
      final anime = Anime.fromJson({
        'id': '1',
        'type': 'anime',
        'attributes': {'slug': 'cowboy-bebop'},
      });

      expect(anime.relationships, isNull);
    });
  });
}
