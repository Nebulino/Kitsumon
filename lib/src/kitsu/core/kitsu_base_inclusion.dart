/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This is the class that represent a [KitsuBaseObject] that can be included
/// in other KitsuBaseObjects.
@JsonSerializable(includeIfNull: false)
class KitsuBaseInclusion {
  /// This is the type of the [KitsuBaseObject].
  @JsonKey(name: 'type')
  String type;

  KitsuBaseInclusion({
    this.type,
  });

  factory KitsuBaseInclusion.fromJson(Map<String, dynamic> json) =>
      _$KitsuBaseInclusionFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuBaseInclusionToJson(this);
}
