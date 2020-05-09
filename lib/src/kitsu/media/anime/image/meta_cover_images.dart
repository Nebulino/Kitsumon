//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different meta information of a Cover Image.
@JsonSerializable(includeIfNull: false)
class MetaCoverImages {
  /// This contains different dimension of a Cover Image.
  @JsonKey(name: 'dimensions')
  CoverDimensions dimensions;

  MetaCoverImages({
    this.dimensions,
  });

  factory MetaCoverImages.fromJson(Map<String, dynamic> json) =>
      _$MetaCoverImagesFromJson(json);

  Map<String, dynamic> toJson() => _$MetaCoverImagesToJson(this);
}
