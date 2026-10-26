//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single manga resource response.
@JsonSerializable(includeIfNull: false)
class MangaResult extends KitsuResponse<Manga, List<KitsuBaseInclusion>> {
  /// The requested manga from the request.
  @override
  Manga? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  MangaResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory MangaResult.fromJson(Map<String, dynamic> json) =>
      _$MangaResultFromJson(json);

  Map<String, dynamic> toJson() => _$MangaResultToJson(this);
}
