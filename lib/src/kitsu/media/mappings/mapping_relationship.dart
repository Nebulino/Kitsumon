//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a mapping.
@JsonSerializable(includeIfNull: false)
class MappingRelationship {
  /// The item (media, etc.) mapped by this record.
  @JsonKey(name: 'item')
  KitsuRelation? item;

  MappingRelationship({
    this.item,
  });

  factory MappingRelationship.fromJson(Map<String, dynamic> json) =>
      _$MappingRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$MappingRelationshipToJson(this);
}
