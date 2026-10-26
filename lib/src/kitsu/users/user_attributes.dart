//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains all the attributes of a [User].
///
/// The counters are `int`, the image maps keep the four sizes Kitsu sends
/// (`tiny`, `small`, `medium`, `large`) and the date-like values are parsed as
/// [DateTime]; everything the API may omit is nullable.
@JsonSerializable(includeIfNull: false)
class UserAttributes {
  /// A short description the user wrote about themselves.
  @JsonKey(name: 'about')
  String? about;

  /// The user's avatar, as a map of size to URL.
  @JsonKey(name: 'avatar')
  Map<String, dynamic>? avatar;

  /// The user's birthday, as the string the API stores.
  @JsonKey(name: 'birthday')
  String? birthday;

  /// How many comments the user wrote.
  @JsonKey(name: 'commentsCount')
  int? commentsCount;

  /// The user's cover image, as a map of size to URL.
  @JsonKey(name: 'coverImage')
  Map<String, dynamic>? coverImage;

  /// When the account was created.
  @JsonKey(name: 'createdAt')
  DateTime? createdAt;

  /// How many titles the user marked as favourite.
  @JsonKey(name: 'favoritesCount')
  int? favoritesCount;

  /// Whether the user completed the onboarding feed.
  @JsonKey(name: 'feedCompleted')
  bool? feedCompleted;

  /// How many users follow this one.
  @JsonKey(name: 'followersCount')
  int? followersCount;

  /// How many users this one follows.
  @JsonKey(name: 'followingCount')
  int? followingCount;

  /// The gender the user declared.
  @JsonKey(name: 'gender')
  String? gender;

  /// The seconds the user spent watching anime.
  @JsonKey(name: 'lifeSpentOnAnime')
  int? lifeSpentOnAnime;

  /// How many likes the user gave.
  @JsonKey(name: 'likesGivenCount')
  int? likesGivenCount;

  /// How many likes the user received.
  @JsonKey(name: 'likesReceivedCount')
  int? likesReceivedCount;

  /// The user's location.
  @JsonKey(name: 'location')
  String? location;

  /// How many reactions the user posted.
  @JsonKey(name: 'mediaReactionsCount')
  int? mediaReactionsCount;

  /// The user's display name.
  @JsonKey(name: 'name')
  String? name;

  /// The names the user used in the past.
  @JsonKey(name: 'pastNames')
  List<String>? pastNames;

  /// The permissions the user has. Kitsu sends either a list or an empty
  /// string, so it is kept untyped on purpose.
  @JsonKey(name: 'permissions')
  Object? permissions;

  /// How many posts the user wrote.
  @JsonKey(name: 'postsCount')
  int? postsCount;

  /// When the user's pro subscription expires, if any.
  @JsonKey(name: 'proExpiresAt')
  DateTime? proExpiresAt;

  /// The pro tier of the user, if any.
  @JsonKey(name: 'proTier')
  String? proTier;

  /// Whether the user completed their profile.
  @JsonKey(name: 'profileCompleted')
  bool? profileCompleted;

  /// How many ratings the user gave.
  @JsonKey(name: 'ratingsCount')
  int? ratingsCount;

  /// How many reviews the user wrote.
  @JsonKey(name: 'reviewsCount')
  int? reviewsCount;

  /// The user's SFW filter preference.
  @JsonKey(name: 'sfwFilterPreference')
  String? sfwFilterPreference;

  /// The user's slug, used in the profile URL.
  @JsonKey(name: 'slug')
  String? slug;

  /// The user's status (`registered`, `banned`, ...).
  @JsonKey(name: 'status')
  String? status;

  /// Whether the user subscribed to the newsletter.
  @JsonKey(name: 'subscribedToNewsletter')
  bool? subscribedToNewsletter;

  /// The user's title, e.g. `Novice`.
  @JsonKey(name: 'title')
  String? title;

  /// When the account was last updated.
  @JsonKey(name: 'updatedAt')
  DateTime? updatedAt;

  /// The character the user picked as waifu or husbando.
  @JsonKey(name: 'waifuOrHusbando')
  String? waifuOrHusbando;

  /// The user's website.
  @JsonKey(name: 'website')
  String? website;

  UserAttributes({
    this.about,
    this.avatar,
    this.birthday,
    this.commentsCount,
    this.coverImage,
    this.createdAt,
    this.favoritesCount,
    this.feedCompleted,
    this.followersCount,
    this.followingCount,
    this.gender,
    this.lifeSpentOnAnime,
    this.likesGivenCount,
    this.likesReceivedCount,
    this.location,
    this.mediaReactionsCount,
    this.name,
    this.pastNames,
    this.permissions,
    this.postsCount,
    this.proExpiresAt,
    this.proTier,
    this.profileCompleted,
    this.ratingsCount,
    this.reviewsCount,
    this.sfwFilterPreference,
    this.slug,
    this.status,
    this.subscribedToNewsletter,
    this.title,
    this.updatedAt,
    this.waifuOrHusbando,
    this.website,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) =>
      _$UserAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttributesToJson(this);
}
