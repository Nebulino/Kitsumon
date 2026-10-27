//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a streaming link.
@JsonSerializable(includeIfNull: false)
class StreamingLinkRelationship {
  /// The streamer service providing the stream.
  @JsonKey(name: 'streamer')
  KitsuRelation? streamer;

  /// The media associated with the streaming link.
  @JsonKey(name: 'media')
  KitsuRelation? media;

  StreamingLinkRelationship({
    this.streamer,
    this.media,
  });

  factory StreamingLinkRelationship.fromJson(Map<String, dynamic> json) =>
      _$StreamingLinkRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingLinkRelationshipToJson(this);
}
