//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the mapping object.
@JsonSerializable(includeIfNull: false)
class Mapping extends KitsuBaseObject<MappingAttributes, MappingRelationship> {
  /// It's the ID of a mapping.
  @override
  int? id;

  /// It indicates the type, in this case is *mappings*.
  @override
  String? type;

  /// It contains the link of the mapping inside the api.
  @override
  String? link;

  /// It contains the attributes of the mapping.
  @override
  MappingAttributes? attributes;

  /// It contains the possible relationships with the mapping.
  @override
  MappingRelationship? relationships;

  Mapping({
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

  factory Mapping.fromJson(Map<String, dynamic> json) =>
      _$MappingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MappingToJson(this);
}
