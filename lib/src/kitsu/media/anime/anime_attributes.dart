//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

@JsonSerializable(includeIfNull: false)
class AnimeAttributes {
  // TODO: check date
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String createdAt;

  // TODO: check date
  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String updatedAt;

  /// The text-like identifier.
  @JsonKey(name: 'slug')
  String slug;

  /// The synopsis of the anime.
  @JsonKey(name: 'synopsis')
  String synopsis;

  /// The title of the anime.
  @JsonKey(name: 'titles')
  AnimeTitle title;

  /// The canonical title of the anime.
  @JsonKey(name: 'canonicalTitle')
  String canonicalTitle;

  /// A list of abbreviated titles of the anime.
  @JsonKey(name: 'abbreviatedTitles')
  List<String> abbreviatedTitles;

  // TODO: it needs to be String?
  /// This is the average rating of the anime
  @JsonKey(name: 'averageRating')
  String averageRating;

  /// This contains different rating frequencies.
  @JsonKey(name: 'ratingsFrequencies')
  RatingFrequencies ratingsFrequencies;

  /// The number of users that have watched the anime.
  @JsonKey(name: 'userCount')
  int userCount;

  /// The number of users that have watched the anime and favorited it.
  @JsonKey(name: 'favoritesCount')
  int favoritesCount;

  // TODO: check date
  /// The starting date of the anime's airing.
  @JsonKey(name: 'startDate')
  String startDate;

  // TODO: check date
  /// The ending date of the anime's airing.
  @JsonKey(name: 'endDate')
  String endDate;

  /// The popularity rank of the anime.
  @JsonKey(name: 'popularityRank')
  int popularityRank;

  /// The rating rank of the anime.
  @JsonKey(name: 'ratingRank')
  int ratingRank;

  /// The age rating of the anime.
  @JsonKey(name: 'ageRating')
  AgeRating ageRating;

  /// A guide for age rating.
  @JsonKey(name: 'ageRatingGuide')
  String ageRatingGuide;

  /// The subtype of the anime.
  @JsonKey(name: 'subtype')
  AnimeSubtype subtype;

  /// The status of airing of the anime.
  @JsonKey(name: 'status')
  AnimeStatus status;

  /// This is the "To Be Announced" section.
  @JsonKey(name: 'tba')
  String tba;

  /// It contains the poster image.
  @JsonKey(name: 'posterImage')
  PosterImage posterImage;

  /// It contains the cover image.
  @JsonKey(name: 'coverImage')
  CoverImage coverImage;

  /// It contains the number of episodes of the anime.
  @JsonKey(name: 'episodeCount')
  int episodeCount;

  /// It contains the length of the episodes.
  @JsonKey(name: 'episodeLength')
  int episodeLength;

  // TODO: need a youtube link builder?
  /// This is the id of a video on [YouTube] about the anime.
  ///
  /// [YouTube]: https://youtube.com
  @JsonKey(name: 'youtubeVideoId')
  String youtubeVideoId;

  /// True if is not safe for work.
  @JsonKey(name: 'nsfw')
  bool nsfw;

  AnimeAttributes({
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.synopsis,
    this.title,
    this.canonicalTitle,
    this.abbreviatedTitles,
    this.averageRating,
    this.ratingsFrequencies,
    this.userCount,
    this.favoritesCount,
    this.startDate,
    this.endDate,
    this.popularityRank,
    this.ratingRank,
    this.ageRating,
    this.ageRatingGuide,
    this.subtype,
    this.status,
    this.tba,
    this.posterImage,
    this.coverImage,
    this.episodeCount,
    this.episodeLength,
    this.youtubeVideoId,
    this.nsfw,
  });

  factory AnimeAttributes.fromJson(Map<String, dynamic> json) =>
      _$AnimeAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeAttributesToJson(this);
}
