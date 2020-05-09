//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different dimension of a Poster Image.
@JsonSerializable(includeIfNull: false)
class PosterDimensions {
  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'tiny')
  ImageDimension tiny;

  /// It contains the information about the *small* version.
  @JsonKey(name: 'small')
  ImageDimension small;

  /// It contains the information about the *medium* version.
  @JsonKey(name: 'medium')
  ImageDimension medium;

  /// It contains the information about the *large* version.
  @JsonKey(name: 'large')
  ImageDimension large;

  PosterDimensions({
    this.tiny,
    this.small,
    this.medium,
    this.large,
  });

  factory PosterDimensions.fromJson(Map<String, dynamic> json) =>
      _$PosterDimensionsFromJson(json);

  Map<String, dynamic> toJson() => _$PosterDimensionsToJson(this);
}
