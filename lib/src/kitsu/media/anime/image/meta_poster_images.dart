//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different meta information of a Poster Image.
@JsonSerializable(includeIfNull: false)
class MetaPosterImages {
  /// This contains different dimension of a Poster Image.
  @JsonKey(name: 'dimensions')
  PosterDimensions dimensions;

  MetaPosterImages({
    this.dimensions,
  });

  factory MetaPosterImages.fromJson(Map<String, dynamic> json) =>
      _$MetaPosterImagesFromJson(json);

  Map<String, dynamic> toJson() => _$MetaPosterImagesToJson(this);
}
