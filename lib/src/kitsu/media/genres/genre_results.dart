//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of genre resources response.
///
/// A response holding a single genre resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class GenreResults extends KitsuResponse<List<Genre>, List<KitsuBaseInclusion>> {
  /// The list of genre from the request.
  @override
  @JsonKey(fromJson: _genreListFromJson)
  List<Genre>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  GenreResults({
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

  factory GenreResults.fromJson(Map<String, dynamic> json) =>
      _$GenreResultsFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResultsToJson(this);
}

List<Genre>? _genreListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Genre.fromJson).toList();
