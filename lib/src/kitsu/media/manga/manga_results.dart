//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of manga resources response.
///
/// A response holding a single manga resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class MangaResults extends KitsuResponse<List<Manga>, List<KitsuBaseInclusion>> {
  /// The list of manga from the request.
  @override
  @JsonKey(fromJson: _mangaListFromJson)
  List<Manga>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  MangaResults({
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

  factory MangaResults.fromJson(Map<String, dynamic> json) =>
      _$MangaResultsFromJson(json);

  Map<String, dynamic> toJson() => _$MangaResultsToJson(this);
}

List<Manga>? _mangaListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Manga.fromJson).toList();
