//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single episode resource response.
@JsonSerializable(includeIfNull: false)
class EpisodeResult extends KitsuResponse<Episode, List<KitsuBaseInclusion>> {
  /// The requested episode from the request.
  @override
  Episode? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  EpisodeResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory EpisodeResult.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResultFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeResultToJson(this);
}
