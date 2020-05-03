/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// It's the anime character relationship object.
@JsonSerializable(includeIfNull: false)
class AnimeRelationship {
  /*
   *  TODO: relations are: genres, categories, castings, installments, mappings,
   *  reviews, mediaRelationship, characters, staff, productions, quotes,
   *  episodes, streamingLinks, animeProductions, animeCharacters, animeStaff
   */

  AnimeRelationship();

  factory AnimeRelationship.fromJson(Map<String, dynamic> json) =>
      _$AnimeRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeRelationshipToJson(this);
}
