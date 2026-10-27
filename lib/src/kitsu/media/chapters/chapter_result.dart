//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single chapter resource response.
@JsonSerializable(includeIfNull: false)
class ChapterResult extends KitsuResponse<Chapter, List<KitsuBaseInclusion>> {
  /// The requested chapter from the request.
  @override
  Chapter? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  ChapterResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory ChapterResult.fromJson(Map<String, dynamic> json) =>
      _$ChapterResultFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterResultToJson(this);
}
