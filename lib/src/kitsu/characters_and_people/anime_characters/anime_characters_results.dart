//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// It manage Anime Characters data.
@JsonSerializable(includeIfNull: false)
class AnimeCharactersResults
    extends KitsuResponse<List<AnimeCharacter>, List<KitsuBaseInclusion>> {
  /// The list of anime characters from the request.
  @override
  List<AnimeCharacter> data;

  /// The list of included relationship.
  @override
  List<KitsuBaseInclusion> included;

  /// The meta information of the request.
  @override
  KitsuMeta meta;

  /// The links information of the request.
  @override
  KitsuLinks links;

  AnimeCharactersResults({
    this.data,
    this.included,
    this.meta,
    this.links,
  }) : super(
          data: data,
          included: included,
          meta: meta,
          links: links,
        );

  factory AnimeCharactersResults.fromJson(Map<String, dynamic> json) =>
      _$AnimeCharactersResultsFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeCharactersResultsToJson(this);
}
