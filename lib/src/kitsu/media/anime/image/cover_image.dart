//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different dimension of a Cover Image.
@JsonSerializable(includeIfNull: false)
class CoverImage {
  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'tiny')
  String tiny;

  /// It contains the information about the *small* version.
  @JsonKey(name: 'small')
  String small;

  /// It contains the information about the *large* version.
  @JsonKey(name: 'large')
  String large;

  /// It contains the information about the *original* version.
  @JsonKey(name: 'original')
  String original;

  /// It contains the information.
  @JsonKey(name: 'meta')
  MetaCoverImages meta;

  CoverImage({
    this.tiny,
    this.small,
    this.large,
    this.original,
    this.meta,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) =>
      _$CoverImageFromJson(json);

  Map<String, dynamic> toJson() => _$CoverImageToJson(this);
}
