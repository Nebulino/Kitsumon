//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of an episode.
@JsonSerializable(includeIfNull: false)
class EpisodeRelationship {
  /// The media the episode belongs to.
  @JsonKey(name: 'media')
  KitsuRelation? media;

  /// The videos of the episode.
  @JsonKey(name: 'videos')
  KitsuRelation? videos;

  EpisodeRelationship({
    this.media,
    this.videos,
  });

  factory EpisodeRelationship.fromJson(Map<String, dynamic> json) =>
      _$EpisodeRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeRelationshipToJson(this);
}
