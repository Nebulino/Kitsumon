//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a character.
@JsonSerializable(includeIfNull: false)
class CharacterRelationship {
  /// The primary media of the character.
  @JsonKey(name: 'primaryMedia')
  KitsuRelation? primaryMedia;

  /// The castings of the character.
  @JsonKey(name: 'castings')
  KitsuRelation? castings;

  /// The media character links.
  @JsonKey(name: 'mediaCharacters')
  KitsuRelation? mediaCharacters;

  /// The quotes spoken by the character.
  @JsonKey(name: 'quotes')
  KitsuRelation? quotes;

  CharacterRelationship({
    this.primaryMedia,
    this.castings,
    this.mediaCharacters,
    this.quotes,
  });

  factory CharacterRelationship.fromJson(Map<String, dynamic> json) =>
      _$CharacterRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterRelationshipToJson(this);
}
