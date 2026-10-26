//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a [User].
@JsonSerializable(includeIfNull: false)
class UserRelationship {
  /// The waifu or husbando the user picked.
  @JsonKey(name: 'waifu')
  KitsuRelation? waifu;

  /// The post the user pinned on their profile.
  @JsonKey(name: 'pinnedPost')
  KitsuRelation? pinnedPost;

  /// The users following this one.
  @JsonKey(name: 'followers')
  KitsuRelation? followers;

  /// The users this one follows.
  @JsonKey(name: 'following')
  KitsuRelation? following;

  /// The users this one blocked.
  @JsonKey(name: 'blocks')
  KitsuRelation? blocks;

  /// The external accounts linked to this profile.
  @JsonKey(name: 'linkedAccounts')
  KitsuRelation? linkedAccounts;

  /// The links shown on the profile.
  @JsonKey(name: 'profileLinks')
  KitsuRelation? profileLinks;

  /// The roles granted to this user.
  @JsonKey(name: 'userRoles')
  KitsuRelation? userRoles;

  /// The library entries of this user.
  @JsonKey(name: 'libraryEntries')
  KitsuRelation? libraryEntries;

  /// The favourites of this user.
  @JsonKey(name: 'favorites')
  KitsuRelation? favorites;

  /// The reviews the user wrote.
  @JsonKey(name: 'reviews')
  KitsuRelation? reviews;

  /// The statistics of this user.
  @JsonKey(name: 'stats')
  KitsuRelation? stats;

  /// The notification settings of this user.
  @JsonKey(name: 'notificationSettings')
  KitsuRelation? notificationSettings;

  /// The OneSignal players registered by this user.
  @JsonKey(name: 'oneSignalPlayers')
  KitsuRelation? oneSignalPlayers;

  /// The categories this user favourited.
  @JsonKey(name: 'categoryFavorites')
  KitsuRelation? categoryFavorites;

  /// The quotes of this user.
  @JsonKey(name: 'quotes')
  KitsuRelation? quotes;

  UserRelationship({
    this.waifu,
    this.pinnedPost,
    this.followers,
    this.following,
    this.blocks,
    this.linkedAccounts,
    this.profileLinks,
    this.userRoles,
    this.libraryEntries,
    this.favorites,
    this.reviews,
    this.stats,
    this.notificationSettings,
    this.oneSignalPlayers,
    this.categoryFavorites,
    this.quotes,
  });

  factory UserRelationship.fromJson(Map<String, dynamic> json) =>
      _$UserRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$UserRelationshipToJson(this);
}
