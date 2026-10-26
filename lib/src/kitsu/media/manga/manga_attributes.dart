//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a manga.
@JsonSerializable(includeIfNull: false)
class MangaAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The text-like identifier.
  @JsonKey(name: 'slug')
  String? slug;

  /// The synopsis of the manga.
  @JsonKey(name: 'synopsis')
  String? synopsis;

  /// The description of the manga.
  @JsonKey(name: 'description')
  String? description;

  /// The vertical offset for the cover image.
  @JsonKey(name: 'coverImageTopOffset')
  int? coverImageTopOffset;

  /// The titles of the manga, keyed by language.
  @JsonKey(name: 'titles')
  MangaTitle? titles;

  /// The canonical title of the manga.
  @JsonKey(name: 'canonicalTitle')
  String? canonicalTitle;

  /// A list of abbreviated titles of the manga.
  @JsonKey(name: 'abbreviatedTitles')
  List<String>? abbreviatedTitles;

  /// The average rating of the manga, as the API sends it: a string.
  @JsonKey(name: 'averageRating')
  String? averageRating;

  /// The different rating frequencies.
  @JsonKey(name: 'ratingFrequencies')
  RatingFrequencies? ratingFrequencies;

  /// The number of users that have the manga in their library.
  @JsonKey(name: 'userCount')
  int? userCount;

  /// The number of users that have favorited the manga.
  @JsonKey(name: 'favoritesCount')
  int? favoritesCount;

  /// The date the manga started being published.
  @JsonKey(name: 'startDate')
  String? startDate;

  /// The date the manga ended being published.
  @JsonKey(name: 'endDate')
  String? endDate;

  /// The date of the next release, when known.
  @JsonKey(name: 'nextRelease')
  String? nextRelease;

  /// The popularity rank of the manga.
  @JsonKey(name: 'popularityRank')
  int? popularityRank;

  /// The rating rank of the manga.
  @JsonKey(name: 'ratingRank')
  int? ratingRank;

  /// The age rating of the manga.
  @JsonKey(name: 'ageRating', unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  AgeRating? ageRating;

  /// A guide for age rating.
  @JsonKey(name: 'ageRatingGuide')
  String? ageRatingGuide;

  /// The subtype of the manga.
  @JsonKey(name: 'subtype', unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  MangaSubtype? subtype;

  /// The publication status of the manga.
  @JsonKey(name: 'status', unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  MangaStatus? status;

  /// This is the "To Be Announced" section.
  @JsonKey(name: 'tba')
  String? tba;

  /// It contains the poster image.
  @JsonKey(name: 'posterImage')
  PosterImage? posterImage;

  /// It contains the cover image, when the manga has one.
  @JsonKey(name: 'coverImage')
  CoverImage? coverImage;

  /// The number of chapters of the manga, when known.
  @JsonKey(name: 'chapterCount')
  int? chapterCount;

  /// The number of volumes of the manga, when known.
  @JsonKey(name: 'volumeCount')
  int? volumeCount;

  /// The magazine the manga was serialized in.
  @JsonKey(name: 'serialization')
  String? serialization;

  /// The manga type representation.
  @JsonKey(name: 'mangaType')
  String? mangaType;

  MangaAttributes({
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.synopsis,
    this.description,
    this.coverImageTopOffset,
    this.titles,
    this.canonicalTitle,
    this.abbreviatedTitles,
    this.averageRating,
    this.ratingFrequencies,
    this.userCount,
    this.favoritesCount,
    this.startDate,
    this.endDate,
    this.nextRelease,
    this.popularityRank,
    this.ratingRank,
    this.ageRating,
    this.ageRatingGuide,
    this.subtype,
    this.status,
    this.tba,
    this.posterImage,
    this.coverImage,
    this.chapterCount,
    this.volumeCount,
    this.serialization,
    this.mangaType,
  });

  factory MangaAttributes.fromJson(Map<String, dynamic> json) =>
      _$MangaAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$MangaAttributesToJson(this);
}
