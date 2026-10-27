//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of episode resources response.
///
/// A response holding a single episode resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class EpisodeResults
    extends KitsuResponse<List<Episode>, List<KitsuBaseInclusion>> {
  /// The list of episodes from the request.
  @override
  @JsonKey(fromJson: _episodeListFromJson)
  List<Episode>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  EpisodeResults({
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

  factory EpisodeResults.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResultsFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeResultsToJson(this);
}

List<Episode>? _episodeListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Episode.fromJson).toList();
