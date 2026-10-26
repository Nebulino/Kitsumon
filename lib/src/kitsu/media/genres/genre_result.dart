//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single genre resource response.
@JsonSerializable(includeIfNull: false)
class GenreResult extends KitsuResponse<Genre, List<KitsuBaseInclusion>> {
  /// The requested genre from the request.
  @override
  Genre? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  GenreResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory GenreResult.fromJson(Map<String, dynamic> json) =>
      _$GenreResultFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResultToJson(this);
}
