//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of Anime resources response.
@JsonSerializable(includeIfNull: false)
class AnimeResults extends KitsuResponse<List<Anime>, List<KitsuBaseInclusion>> {
  /// The list of anime from the request.
  @override
  List<Anime>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  AnimeResults({
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

  factory AnimeResults.fromJson(Map<String, dynamic> json) =>
      _$AnimeResultsFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeResultsToJson(this);
}
