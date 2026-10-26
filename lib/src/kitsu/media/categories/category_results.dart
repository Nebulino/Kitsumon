//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of category resources response.
///
/// A response holding a single category resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class CategoryResults extends KitsuResponse<List<Category>, List<KitsuBaseInclusion>> {
  /// The list of category from the request.
  @override
  @JsonKey(fromJson: _categoryListFromJson)
  List<Category>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  CategoryResults({
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

  factory CategoryResults.fromJson(Map<String, dynamic> json) =>
      _$CategoryResultsFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResultsToJson(this);
}

List<Category>? _categoryListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Category.fromJson).toList();
