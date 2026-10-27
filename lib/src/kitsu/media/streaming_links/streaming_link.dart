//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the streaming link object.
@JsonSerializable(includeIfNull: false)
class StreamingLink extends KitsuBaseObject<StreamingLinkAttributes, StreamingLinkRelationship> {
  /// It's the ID of a streaming link.
  @override
  int? id;

  /// It indicates the type, in this case is *streamingLinks*.
  @override
  String? type;

  /// It contains the link of the streaming link inside the api.
  @override
  String? link;

  /// It contains the attributes of the streaming link.
  @override
  StreamingLinkAttributes? attributes;

  /// It contains the possible relationships with the streaming link.
  @override
  StreamingLinkRelationship? relationships;

  StreamingLink({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  }) : super(
          id: id,
          type: type,
          link: link,
          attributes: attributes,
          relationships: relationships,
        );

  factory StreamingLink.fromJson(Map<String, dynamic> json) =>
      _$StreamingLinkFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StreamingLinkToJson(this);
}
