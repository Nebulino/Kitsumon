//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the episode object.
@JsonSerializable(includeIfNull: false)
class Episode extends KitsuBaseObject<EpisodeAttributes, EpisodeRelationship> {
  /// It's the ID of an episode.
  @override
  int? id;

  /// It indicates the type, in this case is *episodes*.
  @override
  String? type;

  /// It contains the link of the episode inside the api.
  @override
  String? link;

  /// It contains the attributes of the episode.
  @override
  EpisodeAttributes? attributes;

  /// It contains the possible relationships with the episode.
  @override
  EpisodeRelationship? relationships;

  Episode({
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

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
