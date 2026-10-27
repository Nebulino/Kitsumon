//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a mapping.
@JsonSerializable(includeIfNull: false)
class MappingAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The identifier of the external site (e.g. `'myanimelist/anime'`).
  @JsonKey(name: 'externalSite')
  String? externalSite;

  /// The ID on the external site.
  @JsonKey(name: 'externalId')
  String? externalId;

  MappingAttributes({
    this.createdAt,
    this.updatedAt,
    this.externalSite,
    this.externalId,
  });

  factory MappingAttributes.fromJson(Map<String, dynamic> json) =>
      _$MappingAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$MappingAttributesToJson(this);
}
