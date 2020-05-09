//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different dimension of a Cover Image.
@JsonSerializable(includeIfNull: false)
class PosterImage {
  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'tiny')
  String tiny;

  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'small')
  String small;

  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'medium')
  String medium;

  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'large')
  String large;

  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'original')
  String original;

  /// It contains the information.
  @JsonKey(name: 'meta')
  MetaPosterImages meta;

  PosterImage({
    this.tiny,
    this.small,
    this.medium,
    this.large,
    this.original,
    this.meta,
  });

  factory PosterImage.fromJson(Map<String, dynamic> json) =>
      _$PosterImageFromJson(json);

  Map<String, dynamic> toJson() => _$PosterImageToJson(this);
}
