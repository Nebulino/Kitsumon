//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// Relationships of an [Anime] resource.
@JsonSerializable(includeIfNull: false)
class AnimeRelationship {
  /// The genres of the anime.
  @JsonKey(name: 'genres')
  KitsuRelation? genres;

  /// The categories of the anime.
  @JsonKey(name: 'categories')
  KitsuRelation? categories;

  /// The castings of the anime.
  @JsonKey(name: 'castings')
  KitsuRelation? castings;

  /// The installments of the anime.
  @JsonKey(name: 'installments')
  KitsuRelation? installments;

  /// The mappings of the anime to external databases.
  @JsonKey(name: 'mappings')
  KitsuRelation? mappings;

  /// The reviews of the anime.
  @JsonKey(name: 'reviews')
  KitsuRelation? reviews;

  /// The relationships between this anime and other media.
  @JsonKey(name: 'mediaRelationships')
  KitsuRelation? mediaRelationships;

  /// The characters appearing in the anime.
  @JsonKey(name: 'characters')
  KitsuRelation? characters;

  /// The staff members of the anime.
  @JsonKey(name: 'staff')
  KitsuRelation? staff;

  /// The productions of the anime.
  @JsonKey(name: 'productions')
  KitsuRelation? productions;

  /// The quotes from the anime.
  @JsonKey(name: 'quotes')
  KitsuRelation? quotes;

  /// The episodes of the anime.
  @JsonKey(name: 'episodes')
  KitsuRelation? episodes;

  /// The streaming links of the anime.
  @JsonKey(name: 'streamingLinks')
  KitsuRelation? streamingLinks;

  /// The anime productions linking studios and producers to the anime.
  @JsonKey(name: 'animeProductions')
  KitsuRelation? animeProductions;

  /// The anime characters linking characters and roles to the anime.
  @JsonKey(name: 'animeCharacters')
  KitsuRelation? animeCharacters;

  /// The anime staff linking people and roles to the anime.
  @JsonKey(name: 'animeStaff')
  KitsuRelation? animeStaff;

  /// Creates an [AnimeRelationship] bundle.
  AnimeRelationship({
    this.genres,
    this.categories,
    this.castings,
    this.installments,
    this.mappings,
    this.reviews,
    this.mediaRelationships,
    this.characters,
    this.staff,
    this.productions,
    this.quotes,
    this.episodes,
    this.streamingLinks,
    this.animeProductions,
    this.animeCharacters,
    this.animeStaff,
  });

  /// Parses an [AnimeRelationship] from a JSON map, ignoring unknown keys.
  factory AnimeRelationship.fromJson(Map<String, dynamic> json) =>
      _$AnimeRelationshipFromJson(json);

  /// Serializes this [AnimeRelationship] to a JSON map.
  Map<String, dynamic> toJson() => _$AnimeRelationshipToJson(this);
}
