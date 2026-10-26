//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This is a general relation from a [KitsuBaseObject] to any other resource.
///
/// Kitsu answers with the [links] of the relation and, when the related
/// resource was requested, with its linkage in [data]: a single
/// `{type, id}` object for a to-one relation or a list of them for a to-many
/// one.
@JsonSerializable(includeIfNull: false)
class KitsuRelation extends KitsuBaseRelation<dynamic> {
  /// It contains the links about this relation.
  @override
  KitsuRelationshipLinks? links;

  /// It contains the raw linkage of this relation, when present.
  @override
  dynamic data;

  KitsuRelation({
    this.links,
    this.data,
  });

  factory KitsuRelation.fromJson(Map<String, dynamic> json) =>
      _$KitsuRelationFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuRelationToJson(this);
}
