//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of streaming link resources response.
///
/// A response holding a single streaming link resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class StreamingLinkResults
    extends KitsuResponse<List<StreamingLink>, List<KitsuBaseInclusion>> {
  /// The list of streaming links from the request.
  @override
  @JsonKey(fromJson: _streamingLinkListFromJson)
  List<StreamingLink>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  StreamingLinkResults({
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

  factory StreamingLinkResults.fromJson(Map<String, dynamic> json) =>
      _$StreamingLinkResultsFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingLinkResultsToJson(this);
}

List<StreamingLink>? _streamingLinkListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)
        ?.map(StreamingLink.fromJson)
        .toList();
