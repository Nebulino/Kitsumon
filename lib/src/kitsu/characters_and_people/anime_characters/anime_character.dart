//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// It's the anime character object.
@JsonSerializable(includeIfNull: false)
class AnimeCharacter extends KitsuBaseObject<AnimeCharacterAttributes,
    AnimeCharacterRelationship> {
  /// It's the ID of an anime character.
  @override
  int id;

  // TODO: Or force it to be animeCharacter in wrapper-side? Necessary?
  /// It indicates the type, in this case is *animeCharacter* / *character*.
  @override
  String type;

  /// It contains the link of the anime character inside the api.
  @override
  String link;

  /// It contains the attributes of the anime character.
  @override
  AnimeCharacterAttributes attributes;

  /// It contains the possible relationships with the anime character.
  @override
  AnimeCharacterRelationship relationships;

  AnimeCharacter({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  }) : super(
          id: id,
          type: type,
          link: link,
          attributes: attributes,
          relationships: relationships,
        );

  factory AnimeCharacter.fromJson(Map<String, dynamic> json) =>
      _$AnimeCharacterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnimeCharacterToJson(this);
}
