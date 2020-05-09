//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// THis object represents an authentication object.
/// It contains all the important stuff about authenticating on [Kitsu].
///
/// [Kitsu]: https://kitsu.io/
@JsonSerializable(includeIfNull: false)
class Authentication {
  /// This is the important part uf authentication. It contains the access token.
  @JsonKey(
    name: 'access_token',
    required: true,
  )
  String accessToken;

  /// It describe the token type. Usually Bearer.
  @JsonKey(name: 'tokenType')
  String tokenType;

  /// It contains the Duration of the Authentication.
  @JsonKey(
    name: 'expires_in',
    required: true,
    fromJson: KitsuValueNormalizer.SecondsDurationParser,
  )
  Duration expiresIn;

  /// It contains the refresh token.
  @JsonKey(
    name: 'refresh_token',
    required: true,
  )
  String refreshToken;

  /// It describe the scope of the authentication mode. Usually *public*.
  @JsonKey(
    name: 'scope',
    required: true,
  )
  String scope;

  /// It contains the DateTime when this authentication is created.
  @JsonKey(
    name: 'created_at',
    required: true,
    fromJson: KitsuValueNormalizer.UnixTimeDateTimeParser,
  )
  DateTime createdAt;

  Authentication({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.scope,
    this.createdAt,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);
}
