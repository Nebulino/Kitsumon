//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of mapping resources response.
///
/// A response holding a single mapping resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class MappingResults
    extends KitsuResponse<List<Mapping>, List<KitsuBaseInclusion>> {
  /// The list of mappings from the request.
  @override
  @JsonKey(fromJson: _mappingListFromJson)
  List<Mapping>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  MappingResults({
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

  factory MappingResults.fromJson(Map<String, dynamic> json) =>
      _$MappingResultsFromJson(json);

  Map<String, dynamic> toJson() => _$MappingResultsToJson(this);
}

List<Mapping>? _mappingListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Mapping.fromJson).toList();
