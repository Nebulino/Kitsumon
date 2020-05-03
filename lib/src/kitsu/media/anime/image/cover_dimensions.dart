/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This contains different dimension of a Cover Image.
@JsonSerializable(includeIfNull: false)
class CoverDimensions {
  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'tiny')
  ImageDimension tiny;

  /// It contains the information about the *small* version.
  @JsonKey(name: 'small')
  ImageDimension small;

  /// It contains the information about the *large* version.
  @JsonKey(name: 'large')
  ImageDimension large;

  CoverDimensions({
    this.tiny,
    this.small,
    this.large,
  });

  factory CoverDimensions.fromJson(Map<String, dynamic> json) =>
      _$CoverDimensionsFromJson(json);

  Map<String, dynamic> toJson() => _$CoverDimensionsToJson(this);
}
