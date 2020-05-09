//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This object represents the links variable inside a [KitsuResponse].
@JsonSerializable(includeIfNull: false)
class KitsuRelationshipLinks {
  // TODO: transform in URI?
  /// This is the link of the relation inside the Kitsu Api.
  @JsonKey(name: 'self')
  String self;

  // TODO: transform in URI?
  /// This is the link of the related information inside the Kitsu Api.
  @JsonKey(name: 'related')
  String related;

  KitsuRelationshipLinks({
    this.self,
    this.related,
  });

  factory KitsuRelationshipLinks.fromJson(Map<String, dynamic> json) =>
      _$KitsuRelationshipLinksFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuRelationshipLinksToJson(this);
}
