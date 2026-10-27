//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of chapter resources response.
///
/// A response holding a single chapter resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class ChapterResults
    extends KitsuResponse<List<Chapter>, List<KitsuBaseInclusion>> {
  /// The list of chapters from the request.
  @override
  @JsonKey(fromJson: _chapterListFromJson)
  List<Chapter>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  ChapterResults({
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

  factory ChapterResults.fromJson(Map<String, dynamic> json) =>
      _$ChapterResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterResultsToJson(this);
}

List<Chapter>? _chapterListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Chapter.fromJson).toList();
