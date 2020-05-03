/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This is a general relation from a [KitsuBaseObject] to a **Character** object.
@JsonSerializable(includeIfNull: false)
class CharacterRelation extends KitsuBaseRelation<KitsuBaseRelationData> {
  /// It contains the links about this relation.
  @override
  KitsuRelationshipLinks links;

  /// It contains the data about this relation.
  @override
  KitsuBaseRelationData data;

  CharacterRelation({
    this.links,
    this.data,
  });

  factory CharacterRelation.fromJson(Map<String, dynamic> json) =>
      _$CharacterRelationFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterRelationToJson(this);
}
