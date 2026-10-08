//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This contains different dimension of a Poster Image.
@JsonSerializable(includeIfNull: false)
class PosterImage {
  /// It contains the information about the *tiny* version.
  @JsonKey(name: 'tiny')
  String? tiny;

  /// It contains the information about the *small* version.
  @JsonKey(name: 'small')
  String? small;

  /// It contains the information about the *medium* version.
  @JsonKey(name: 'medium')
  String? medium;

  /// It contains the information about the *large* version.
  @JsonKey(name: 'large')
  String? large;

  /// It contains the information about the *original* version.
  @JsonKey(name: 'original')
  String? original;

  /// It contains the information.
  @JsonKey(name: 'meta')
  MetaPosterImages? meta;

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
