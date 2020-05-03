/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This is a general relation from a [KitsuBaseObject] to a **Castings** object.
@JsonSerializable(includeIfNull: false)
class CastingsRelation extends KitsuBaseRelation<List<KitsuBaseRelationData>> {
  /// It contains the links about this relation.
  @override
  KitsuRelationshipLinks links;

  /// It contains the data about this relation.
  @override
  List<KitsuBaseRelationData> data;

  CastingsRelation({
    this.links,
    this.data,
  });

  factory CastingsRelation.fromJson(Map<String, dynamic> json) =>
      _$CastingsRelationFromJson(json);

  Map<String, dynamic> toJson() => _$CastingsRelationToJson(this);
}
