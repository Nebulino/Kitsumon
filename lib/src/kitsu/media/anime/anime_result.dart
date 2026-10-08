//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single Anime resource response.
@JsonSerializable(includeIfNull: false)
class AnimeResult extends KitsuResponse<Anime, List<KitsuBaseInclusion>> {
  /// The requested anime from the request.
  @override
  Anime? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  AnimeResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory AnimeResult.fromJson(Map<String, dynamic> json) =>
      _$AnimeResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeResultToJson(this);
}
