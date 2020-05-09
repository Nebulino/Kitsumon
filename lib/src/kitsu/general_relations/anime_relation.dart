//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This is a general relation from a [KitsuBaseObject] to an **Anime** object.
@JsonSerializable(includeIfNull: false)
class AnimeRelation extends KitsuBaseRelation<KitsuBaseRelationData> {
  /// It contains the links about this relation.
  @override
  KitsuRelationshipLinks links;

  /// It contains the data about this relation.
  @override
  KitsuBaseRelationData data;

  AnimeRelation({
    this.links,
    this.data,
  });

  factory AnimeRelation.fromJson(Map<String, dynamic> json) =>
      _$AnimeRelationFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeRelationToJson(this);
}
