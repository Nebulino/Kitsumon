//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single streaming link resource response.
@JsonSerializable(includeIfNull: false)
class StreamingLinkResult
    extends KitsuResponse<StreamingLink, List<KitsuBaseInclusion>> {
  /// The requested streaming link from the request.
  @override
  StreamingLink? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  StreamingLinkResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory StreamingLinkResult.fromJson(Map<String, dynamic> json) =>
      _$StreamingLinkResultFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingLinkResultToJson(this);
}
