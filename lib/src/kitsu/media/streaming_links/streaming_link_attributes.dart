//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a streaming link.
@JsonSerializable(includeIfNull: false)
class StreamingLinkAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The destination URL of the stream.
  @JsonKey(name: 'url')
  String? url;

  /// The available subtitle languages (e.g. `['en']`).
  @JsonKey(name: 'subs')
  List<String>? subs;

  /// The available dub languages (e.g. `['ja']`).
  @JsonKey(name: 'dubs')
  List<String>? dubs;

  StreamingLinkAttributes({
    this.createdAt,
    this.updatedAt,
    this.url,
    this.subs,
    this.dubs,
  });

  factory StreamingLinkAttributes.fromJson(Map<String, dynamic> json) =>
      _$StreamingLinkAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingLinkAttributesToJson(this);
}
