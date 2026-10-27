//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single mapping resource response.
@JsonSerializable(includeIfNull: false)
class MappingResult extends KitsuResponse<Mapping, List<KitsuBaseInclusion>> {
  /// The requested mapping from the request.
  @override
  Mapping? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  MappingResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory MappingResult.fromJson(Map<String, dynamic> json) =>
      _$MappingResultFromJson(json);

  Map<String, dynamic> toJson() => _$MappingResultToJson(this);
}
