/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

@JsonSerializable(includeIfNull: false)
class AnimeCharacterAttributes {

  // TODO: Check the date
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String createdAt;

  // TODO: Check the date
  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String updatedAt;

  /// The anime character role.
  @JsonKey(name: 'role')
  AnimeCharacterRole role;

  AnimeCharacterAttributes({
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory AnimeCharacterAttributes.fromJson(Map<String, dynamic> json) =>
      _$AnimeCharacterAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeCharacterAttributesToJson(this);
}
