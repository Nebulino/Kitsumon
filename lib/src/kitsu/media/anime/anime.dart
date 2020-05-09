//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// It's the anime character object.
@JsonSerializable(includeIfNull: false)
class Anime extends KitsuBaseObject<AnimeAttributes, AnimeRelationship> {
  /// It's the ID of an anime.
  @override
  int id;

  // TODO: Or force it to be animeCharacter in wrapper-side? Necessary?
  /// It indicates the type, in this case is *anime*.
  @override
  String type;

  /// It contains the link of the anime inside the api.
  @override
  String link;

  /// It contains the attributes of the anime.
  @override
  AnimeAttributes attributes;

  /// It contains the possible relationships with the anime.
  @override
  AnimeRelationship relationships;

  Anime({
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

  factory Anime.fromJson(Map<String, dynamic> json) =>
      _$AnimeFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}
