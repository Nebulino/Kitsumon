//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of an episode.
@JsonSerializable(includeIfNull: false)
class EpisodeAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The synopsis of the episode.
  @JsonKey(name: 'synopsis')
  String? synopsis;

  /// The description of the episode.
  @JsonKey(name: 'description')
  String? description;

  /// The titles of the episode keyed by language.
  @JsonKey(name: 'titles')
  Map<String, dynamic>? titles;

  /// The canonical title of the episode.
  @JsonKey(name: 'canonicalTitle')
  String? canonicalTitle;

  /// The season number of the episode.
  @JsonKey(name: 'seasonNumber')
  int? seasonNumber;

  /// The episode number.
  @JsonKey(name: 'number')
  int? number;

  /// The relative episode number.
  @JsonKey(name: 'relativeNumber')
  int? relativeNumber;

  /// The airdate of the episode.
  @JsonKey(name: 'airdate')
  String? airdate;

  /// The length of the episode in minutes or seconds.
  @JsonKey(name: 'length')
  int? length;

  /// The thumbnail image of the episode.
  @JsonKey(name: 'thumbnail')
  Map<String, dynamic>? thumbnail;

  EpisodeAttributes({
    this.createdAt,
    this.updatedAt,
    this.synopsis,
    this.description,
    this.titles,
    this.canonicalTitle,
    this.seasonNumber,
    this.number,
    this.relativeNumber,
    this.airdate,
    this.length,
    this.thumbnail,
  });

  factory EpisodeAttributes.fromJson(Map<String, dynamic> json) =>
      _$EpisodeAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeAttributesToJson(this);
}
