//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single category resource response.
@JsonSerializable(includeIfNull: false)
class CategoryResult extends KitsuResponse<Category, List<KitsuBaseInclusion>> {
  /// The requested category from the request.
  @override
  Category? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  CategoryResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory CategoryResult.fromJson(Map<String, dynamic> json) =>
      _$CategoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResultToJson(this);
}
