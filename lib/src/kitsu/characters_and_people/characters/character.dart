//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the character object.
@JsonSerializable(includeIfNull: false)
class Character extends KitsuBaseObject<CharacterAttributes, CharacterRelationship> {
  /// It's the ID of a character.
  @override
  int? id;

  /// It indicates the type, in this case is *characters*.
  @override
  String? type;

  /// It contains the link of the character inside the api.
  @override
  String? link;

  /// It contains the attributes of the character.
  @override
  CharacterAttributes? attributes;

  /// It contains the possible relationships with the character.
  @override
  CharacterRelationship? relationships;

  Character({
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

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
