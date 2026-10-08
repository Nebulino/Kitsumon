// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitsu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KitsuBaseInclusion _$KitsuBaseInclusionFromJson(Map<String, dynamic> json) =>
    KitsuBaseInclusion(type: json['type'] as String?);

Map<String, dynamic> _$KitsuBaseInclusionToJson(KitsuBaseInclusion instance) =>
    <String, dynamic>{'type': ?instance.type};

KitsuBaseRelationData _$KitsuBaseRelationDataFromJson(
  Map<String, dynamic> json,
) => KitsuBaseRelationData(
  type: json['type'] as String?,
  id: KitsuValueNormalizer.StringToInt(json['id']),
);

Map<String, dynamic> _$KitsuBaseRelationDataToJson(
  KitsuBaseRelationData instance,
) => <String, dynamic>{'type': ?instance.type, 'id': ?instance.id};

KitsuLinks _$KitsuLinksFromJson(Map<String, dynamic> json) => KitsuLinks(
  first: json['first'] as String?,
  prev: json['prev'] as String?,
  next: json['next'] as String?,
  last: json['last'] as String?,
);

Map<String, dynamic> _$KitsuLinksToJson(KitsuLinks instance) =>
    <String, dynamic>{
      'first': ?instance.first,
      'prev': ?instance.prev,
      'next': ?instance.next,
      'last': ?instance.last,
    };

KitsuMeta _$KitsuMetaFromJson(Map<String, dynamic> json) =>
    KitsuMeta(count: (json['count'] as num?)?.toInt());

Map<String, dynamic> _$KitsuMetaToJson(KitsuMeta instance) => <String, dynamic>{
  'count': ?instance.count,
};

KitsuRelationshipLinks _$KitsuRelationshipLinksFromJson(
  Map<String, dynamic> json,
) => KitsuRelationshipLinks(
  self: json['self'] as String?,
  related: json['related'] as String?,
);

Map<String, dynamic> _$KitsuRelationshipLinksToJson(
  KitsuRelationshipLinks instance,
) => <String, dynamic>{'self': ?instance.self, 'related': ?instance.related};

AnimeRelation _$AnimeRelationFromJson(
  Map<String, dynamic> json,
) => AnimeRelation(
  links: json['links'] == null
      ? null
      : KitsuRelationshipLinks.fromJson(json['links'] as Map<String, dynamic>),
  data: json['data'] == null
      ? null
      : KitsuBaseRelationData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnimeRelationToJson(AnimeRelation instance) =>
    <String, dynamic>{'links': ?instance.links, 'data': ?instance.data};

CastingsRelation _$CastingsRelationFromJson(
  Map<String, dynamic> json,
) => CastingsRelation(
  links: json['links'] == null
      ? null
      : KitsuRelationshipLinks.fromJson(json['links'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => KitsuBaseRelationData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CastingsRelationToJson(CastingsRelation instance) =>
    <String, dynamic>{'links': ?instance.links, 'data': ?instance.data};

CharacterRelation _$CharacterRelationFromJson(
  Map<String, dynamic> json,
) => CharacterRelation(
  links: json['links'] == null
      ? null
      : KitsuRelationshipLinks.fromJson(json['links'] as Map<String, dynamic>),
  data: json['data'] == null
      ? null
      : KitsuBaseRelationData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CharacterRelationToJson(CharacterRelation instance) =>
    <String, dynamic>{'links': ?instance.links, 'data': ?instance.data};

Authentication _$AuthenticationFromJson(Map<String, dynamic> json) =>
    Authentication(
      accessToken: json['access_token'] as String?,
      tokenType: json['tokenType'] as String?,
      expiresIn: KitsuValueNormalizer.SecondsDurationParser(json['expires_in']),
      refreshToken: json['refresh_token'] as String?,
      scope: json['scope'] as String?,
      createdAt: KitsuValueNormalizer.UnixTimeDateTimeParser(
        json['created_at'],
      ),
    );

Map<String, dynamic> _$AuthenticationToJson(Authentication instance) =>
    <String, dynamic>{
      'access_token': ?instance.accessToken,
      'tokenType': ?instance.tokenType,
      'expires_in': ?instance.expiresIn?.inMicroseconds,
      'refresh_token': ?instance.refreshToken,
      'scope': ?instance.scope,
      'created_at': ?instance.createdAt?.toIso8601String(),
    };

AnimeCharacter _$AnimeCharacterFromJson(Map<String, dynamic> json) =>
    AnimeCharacter(
      id: KitsuValueNormalizer.StringToInt(json['id']),
      type: json['type'] as String?,
      link: KitsuValueNormalizer.ApiSelfLinkExtractor(json['links']),
      attributes: json['attributes'] == null
          ? null
          : AnimeCharacterAttributes.fromJson(
              json['attributes'] as Map<String, dynamic>,
            ),
      relationships: json['relationships'] == null
          ? null
          : AnimeCharacterRelationship.fromJson(
              json['relationships'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AnimeCharacterToJson(AnimeCharacter instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'type': ?instance.type,
      'links': ?instance.link,
      'attributes': ?instance.attributes,
      'relationships': ?instance.relationships,
    };

AnimeCharacterAttributes _$AnimeCharacterAttributesFromJson(
  Map<String, dynamic> json,
) => AnimeCharacterAttributes(
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  role: $enumDecodeNullable(_$AnimeCharacterRoleEnumMap, json['role']),
);

Map<String, dynamic> _$AnimeCharacterAttributesToJson(
  AnimeCharacterAttributes instance,
) => <String, dynamic>{
  'createdAt': ?instance.createdAt,
  'updatedAt': ?instance.updatedAt,
  'role': ?_$AnimeCharacterRoleEnumMap[instance.role],
};

const _$AnimeCharacterRoleEnumMap = {
  AnimeCharacterRole.main: 'main',
  AnimeCharacterRole.supporting: 'supporting',
};

AnimeCharacterRelationship _$AnimeCharacterRelationshipFromJson(
  Map<String, dynamic> json,
) => AnimeCharacterRelationship(
  anime: json['anime'] == null
      ? null
      : AnimeRelation.fromJson(json['anime'] as Map<String, dynamic>),
  character: json['character'] == null
      ? null
      : CharacterRelation.fromJson(json['character'] as Map<String, dynamic>),
  castings: json['castings'] == null
      ? null
      : CastingsRelation.fromJson(json['castings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnimeCharacterRelationshipToJson(
  AnimeCharacterRelationship instance,
) => <String, dynamic>{
  'anime': ?instance.anime,
  'character': ?instance.character,
  'castings': ?instance.castings,
};

AnimeCharacterResult _$AnimeCharacterResultFromJson(
  Map<String, dynamic> json,
) =>
    AnimeCharacterResult(
        data: json['data'] == null
            ? null
            : AnimeCharacter.fromJson(json['data'] as Map<String, dynamic>),
        included: inclusionExtractor(json['included']),
      )
      ..meta = json['meta'] == null
          ? null
          : KitsuMeta.fromJson(json['meta'] as Map<String, dynamic>)
      ..links = json['links'] == null
          ? null
          : KitsuLinks.fromJson(json['links'] as Map<String, dynamic>);

Map<String, dynamic> _$AnimeCharacterResultToJson(
  AnimeCharacterResult instance,
) => <String, dynamic>{
  'meta': ?instance.meta,
  'links': ?instance.links,
  'data': ?instance.data,
  'included': ?instance.included,
};

AnimeCharactersResults _$AnimeCharactersResultsFromJson(
  Map<String, dynamic> json,
) => AnimeCharactersResults(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => AnimeCharacter.fromJson(e as Map<String, dynamic>))
      .toList(),
  included: inclusionExtractor(json['included']),
  meta: json['meta'] == null
      ? null
      : KitsuMeta.fromJson(json['meta'] as Map<String, dynamic>),
  links: json['links'] == null
      ? null
      : KitsuLinks.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnimeCharactersResultsToJson(
  AnimeCharactersResults instance,
) => <String, dynamic>{
  'data': ?instance.data,
  'included': ?instance.included,
  'meta': ?instance.meta,
  'links': ?instance.links,
};

CoverDimensions _$CoverDimensionsFromJson(Map<String, dynamic> json) =>
    CoverDimensions(
      tiny: json['tiny'] == null
          ? null
          : ImageDimension.fromJson(json['tiny'] as Map<String, dynamic>),
      small: json['small'] == null
          ? null
          : ImageDimension.fromJson(json['small'] as Map<String, dynamic>),
      large: json['large'] == null
          ? null
          : ImageDimension.fromJson(json['large'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoverDimensionsToJson(CoverDimensions instance) =>
    <String, dynamic>{
      'tiny': ?instance.tiny,
      'small': ?instance.small,
      'large': ?instance.large,
    };

CoverImage _$CoverImageFromJson(Map<String, dynamic> json) => CoverImage(
  tiny: json['tiny'] as String?,
  small: json['small'] as String?,
  large: json['large'] as String?,
  original: json['original'] as String?,
  meta: json['meta'] == null
      ? null
      : MetaCoverImages.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoverImageToJson(CoverImage instance) =>
    <String, dynamic>{
      'tiny': ?instance.tiny,
      'small': ?instance.small,
      'large': ?instance.large,
      'original': ?instance.original,
      'meta': ?instance.meta,
    };

ImageDimension _$ImageDimensionFromJson(Map<String, dynamic> json) =>
    ImageDimension(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ImageDimensionToJson(ImageDimension instance) =>
    <String, dynamic>{'width': ?instance.width, 'height': ?instance.height};

MetaCoverImages _$MetaCoverImagesFromJson(Map<String, dynamic> json) =>
    MetaCoverImages(
      dimensions: json['dimensions'] == null
          ? null
          : CoverDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MetaCoverImagesToJson(MetaCoverImages instance) =>
    <String, dynamic>{'dimensions': ?instance.dimensions};

MetaPosterImages _$MetaPosterImagesFromJson(Map<String, dynamic> json) =>
    MetaPosterImages(
      dimensions: json['dimensions'] == null
          ? null
          : PosterDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MetaPosterImagesToJson(MetaPosterImages instance) =>
    <String, dynamic>{'dimensions': ?instance.dimensions};

PosterDimensions _$PosterDimensionsFromJson(Map<String, dynamic> json) =>
    PosterDimensions(
      tiny: json['tiny'] == null
          ? null
          : ImageDimension.fromJson(json['tiny'] as Map<String, dynamic>),
      small: json['small'] == null
          ? null
          : ImageDimension.fromJson(json['small'] as Map<String, dynamic>),
      medium: json['medium'] == null
          ? null
          : ImageDimension.fromJson(json['medium'] as Map<String, dynamic>),
      large: json['large'] == null
          ? null
          : ImageDimension.fromJson(json['large'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PosterDimensionsToJson(PosterDimensions instance) =>
    <String, dynamic>{
      'tiny': ?instance.tiny,
      'small': ?instance.small,
      'medium': ?instance.medium,
      'large': ?instance.large,
    };

PosterImage _$PosterImageFromJson(Map<String, dynamic> json) => PosterImage(
  tiny: json['tiny'] as String?,
  small: json['small'] as String?,
  medium: json['medium'] as String?,
  large: json['large'] as String?,
  original: json['original'] as String?,
  meta: json['meta'] == null
      ? null
      : MetaPosterImages.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PosterImageToJson(PosterImage instance) =>
    <String, dynamic>{
      'tiny': ?instance.tiny,
      'small': ?instance.small,
      'medium': ?instance.medium,
      'large': ?instance.large,
      'original': ?instance.original,
      'meta': ?instance.meta,
    };

AnimeAttributes _$AnimeAttributesFromJson(Map<String, dynamic> json) =>
    AnimeAttributes(
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      slug: json['slug'] as String?,
      synopsis: json['synopsis'] as String?,
      description: json['description'] as String?,
      coverImageTopOffset: (json['coverImageTopOffset'] as num?)?.toInt(),
      title: json['titles'] == null
          ? null
          : AnimeTitle.fromJson(json['titles'] as Map<String, dynamic>),
      canonicalTitle: json['canonicalTitle'] as String?,
      abbreviatedTitles: (json['abbreviatedTitles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      averageRating: json['averageRating'] as String?,
      ratingFrequencies: json['ratingFrequencies'] == null
          ? null
          : RatingFrequencies.fromJson(
              json['ratingFrequencies'] as Map<String, dynamic>,
            ),
      userCount: (json['userCount'] as num?)?.toInt(),
      favoritesCount: (json['favoritesCount'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      nextRelease: json['nextRelease'] as String?,
      popularityRank: (json['popularityRank'] as num?)?.toInt(),
      ratingRank: (json['ratingRank'] as num?)?.toInt(),
      ageRating: $enumDecodeNullable(_$AgeRatingEnumMap, json['ageRating']),
      ageRatingGuide: json['ageRatingGuide'] as String?,
      subtype: $enumDecodeNullable(_$AnimeSubtypeEnumMap, json['subtype']),
      status: $enumDecodeNullable(_$AnimeStatusEnumMap, json['status']),
      tba: json['tba'] as String?,
      posterImage: json['posterImage'] == null
          ? null
          : PosterImage.fromJson(json['posterImage'] as Map<String, dynamic>),
      coverImage: json['coverImage'] == null
          ? null
          : CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>),
      episodeCount: (json['episodeCount'] as num?)?.toInt(),
      episodeLength: (json['episodeLength'] as num?)?.toInt(),
      totalLength: (json['totalLength'] as num?)?.toInt(),
      youtubeVideoId: json['youtubeVideoId'] as String?,
      showType: json['showType'] as String?,
      nsfw: json['nsfw'] as bool?,
    );

Map<String, dynamic> _$AnimeAttributesToJson(AnimeAttributes instance) =>
    <String, dynamic>{
      'createdAt': ?instance.createdAt,
      'updatedAt': ?instance.updatedAt,
      'slug': ?instance.slug,
      'synopsis': ?instance.synopsis,
      'description': ?instance.description,
      'coverImageTopOffset': ?instance.coverImageTopOffset,
      'titles': ?instance.title,
      'canonicalTitle': ?instance.canonicalTitle,
      'abbreviatedTitles': ?instance.abbreviatedTitles,
      'averageRating': ?instance.averageRating,
      'ratingFrequencies': ?instance.ratingFrequencies,
      'userCount': ?instance.userCount,
      'favoritesCount': ?instance.favoritesCount,
      'startDate': ?instance.startDate,
      'endDate': ?instance.endDate,
      'nextRelease': ?instance.nextRelease,
      'popularityRank': ?instance.popularityRank,
      'ratingRank': ?instance.ratingRank,
      'ageRating': ?_$AgeRatingEnumMap[instance.ageRating],
      'ageRatingGuide': ?instance.ageRatingGuide,
      'subtype': ?_$AnimeSubtypeEnumMap[instance.subtype],
      'status': ?_$AnimeStatusEnumMap[instance.status],
      'tba': ?instance.tba,
      'posterImage': ?instance.posterImage,
      'coverImage': ?instance.coverImage,
      'episodeCount': ?instance.episodeCount,
      'episodeLength': ?instance.episodeLength,
      'totalLength': ?instance.totalLength,
      'youtubeVideoId': ?instance.youtubeVideoId,
      'showType': ?instance.showType,
      'nsfw': ?instance.nsfw,
    };

const _$AgeRatingEnumMap = {
  AgeRating.G: 'G',
  AgeRating.PG: 'PG',
  AgeRating.R: 'R',
  AgeRating.R18: 'R18',
};

const _$AnimeSubtypeEnumMap = {
  AnimeSubtype.ONA: 'ONA',
  AnimeSubtype.OVA: 'OVA',
  AnimeSubtype.TV: 'TV',
  AnimeSubtype.movie: 'movie',
  AnimeSubtype.music: 'music',
  AnimeSubtype.special: 'special',
};

const _$AnimeStatusEnumMap = {
  AnimeStatus.current: 'current',
  AnimeStatus.finished: 'finished',
  AnimeStatus.tba: 'tba',
  AnimeStatus.unreleased: 'unreleased',
  AnimeStatus.upcoming: 'upcoming',
};

Anime _$AnimeFromJson(Map<String, dynamic> json) => Anime(
  id: KitsuValueNormalizer.StringToInt(json['id']),
  type: json['type'] as String?,
  link: KitsuValueNormalizer.ApiSelfLinkExtractor(json['links']),
  attributes: json['attributes'] == null
      ? null
      : AnimeAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
  relationships: json['relationships'] == null
      ? null
      : AnimeRelationship.fromJson(
          json['relationships'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AnimeToJson(Anime instance) => <String, dynamic>{
  'id': ?instance.id,
  'type': ?instance.type,
  'links': ?instance.link,
  'attributes': ?instance.attributes,
  'relationships': ?instance.relationships,
};

AnimeResult _$AnimeResultFromJson(Map<String, dynamic> json) =>
    AnimeResult(
        data: json['data'] == null
            ? null
            : Anime.fromJson(json['data'] as Map<String, dynamic>),
        included: inclusionExtractor(json['included']),
      )
      ..meta = json['meta'] == null
          ? null
          : KitsuMeta.fromJson(json['meta'] as Map<String, dynamic>)
      ..links = json['links'] == null
          ? null
          : KitsuLinks.fromJson(json['links'] as Map<String, dynamic>);

Map<String, dynamic> _$AnimeResultToJson(AnimeResult instance) =>
    <String, dynamic>{
      'meta': ?instance.meta,
      'links': ?instance.links,
      'data': ?instance.data,
      'included': ?instance.included,
    };

AnimeResults _$AnimeResultsFromJson(Map<String, dynamic> json) => AnimeResults(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Anime.fromJson(e as Map<String, dynamic>))
      .toList(),
  included: inclusionExtractor(json['included']),
  meta: json['meta'] == null
      ? null
      : KitsuMeta.fromJson(json['meta'] as Map<String, dynamic>),
  links: json['links'] == null
      ? null
      : KitsuLinks.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnimeResultsToJson(AnimeResults instance) =>
    <String, dynamic>{
      'data': ?instance.data,
      'included': ?instance.included,
      'meta': ?instance.meta,
      'links': ?instance.links,
    };

AnimeRelationship _$AnimeRelationshipFromJson(Map<String, dynamic> json) =>
    AnimeRelationship();

Map<String, dynamic> _$AnimeRelationshipToJson(AnimeRelationship instance) =>
    <String, dynamic>{};

AnimeTitle _$AnimeTitleFromJson(Map<String, dynamic> json) => AnimeTitle(
  english: json['en'] as String?,
  japaneseRomaji: json['en_jp'] as String?,
  japanese: json['ja_jp'] as String?,
);

Map<String, dynamic> _$AnimeTitleToJson(AnimeTitle instance) =>
    <String, dynamic>{
      'en': ?instance.english,
      'en_jp': ?instance.japaneseRomaji,
      'ja_jp': ?instance.japanese,
    };

RatingFrequencies _$RatingFrequenciesFromJson(Map<String, dynamic> json) =>
    RatingFrequencies(
      $2: json['2'] as String?,
      $3: json['3'] as String?,
      $4: json['4'] as String?,
      $5: json['5'] as String?,
      $6: json['6'] as String?,
      $7: json['7'] as String?,
      $8: json['8'] as String?,
      $9: json['9'] as String?,
      $10: json['10'] as String?,
      $11: json['11'] as String?,
      $12: json['12'] as String?,
      $13: json['13'] as String?,
      $14: json['14'] as String?,
      $15: json['15'] as String?,
      $16: json['16'] as String?,
      $17: json['17'] as String?,
      $18: json['18'] as String?,
      $19: json['19'] as String?,
      $20: json['20'] as String?,
    );

Map<String, dynamic> _$RatingFrequenciesToJson(RatingFrequencies instance) =>
    <String, dynamic>{
      '2': ?instance.$2,
      '3': ?instance.$3,
      '4': ?instance.$4,
      '5': ?instance.$5,
      '6': ?instance.$6,
      '7': ?instance.$7,
      '8': ?instance.$8,
      '9': ?instance.$9,
      '10': ?instance.$10,
      '11': ?instance.$11,
      '12': ?instance.$12,
      '13': ?instance.$13,
      '14': ?instance.$14,
      '15': ?instance.$15,
      '16': ?instance.$16,
      '17': ?instance.$17,
      '18': ?instance.$18,
      '19': ?instance.$19,
      '20': ?instance.$20,
    };
