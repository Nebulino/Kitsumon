//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// It manage Anime Characters data.
@JsonSerializable(includeIfNull: false)
class AnimeCharacterResult
    extends KitsuResponse<AnimeCharacter, List<KitsuBaseInclusion>> {
  /// The requested anime character from the request.
  @override
  AnimeCharacter data;

  /// The list of included relationship.
  @override
  List<KitsuBaseInclusion> included;

  AnimeCharacterResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory AnimeCharacterResult.fromJson(Map<String, dynamic> json) =>
      _$AnimeCharacterResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeCharacterResultToJson(this);
}
