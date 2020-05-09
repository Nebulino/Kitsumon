//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// It's the anime character relationship object.
@JsonSerializable(includeIfNull: false)
class AnimeCharacterRelationship {
  /// The information about the related anime with the anime character.
  @JsonKey(name: 'anime')
  AnimeRelation anime;

  /// The information about the related character with the anime character.
  @JsonKey(name: 'character')
  CharacterRelation character;

  /// The information about the related castings with the anime character.
  @JsonKey(name: 'castings')
  CastingsRelation castings;

  AnimeCharacterRelationship({
    this.anime,
    this.character,
    this.castings,
  });

  factory AnimeCharacterRelationship.fromJson(Map<String, dynamic> json) =>
      _$AnimeCharacterRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeCharacterRelationshipToJson(this);
}
