/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// It contains the information about the a defined dimension version.
@JsonSerializable(includeIfNull: false)
class ImageDimension {
  /// It's the width of the image.
  @JsonKey(name: 'width')
  int width;

  /// It's the height of the image.
  @JsonKey(name: 'height')
  int height;

  ImageDimension({
    this.width,
    this.height,
  });

  factory ImageDimension.fromJson(Map<String, dynamic> json) =>
      _$ImageDimensionFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDimensionToJson(this);
}
