//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// OAuth2 token credentials returned by Kitsu.
@JsonSerializable(includeIfNull: false)
class Authentication {
  /// The OAuth2 access token used as a bearer credential.
  @JsonKey(
    name: 'access_token',
  )
  String? accessToken;

  /// The token type returned by the OAuth2 endpoint (usually `bearer`).
  @JsonKey(name: 'token_type')
  String? tokenType;

  /// The lifetime of the access token.
  @JsonKey(
    name: 'expires_in',
    fromJson: KitsuValueNormalizer.SecondsDurationParser,
  )
  Duration? expiresIn;

  /// The refresh token used to obtain a new access token when this one expires.
  @JsonKey(
    name: 'refresh_token',
  )
  String? refreshToken;

  /// The granted OAuth2 scope (usually `public`).
  @JsonKey(
    name: 'scope',
  )
  String? scope;

  /// When this authentication token was created.
  @JsonKey(
    name: 'created_at',
    fromJson: KitsuValueNormalizer.UnixTimeDateTimeParser,
  )
  DateTime? createdAt;

  /// Creates an [Authentication] token bundle.
  Authentication({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.scope,
    this.createdAt,
  });

  /// Whether the access token has expired or will expire within 30 seconds.
  ///
  /// Returns `false` when either [createdAt] or [expiresIn] is `null`.
  bool get isExpired {
    final created = createdAt;
    final lifetime = expiresIn;
    if (created == null || lifetime == null) {
      return false;
    }
    return !created.add(lifetime).isAfter(
          DateTime.now().add(const Duration(seconds: 30)),
        );
  }

  /// Parses an [Authentication] from a JSON map.
  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  /// Serializes this [Authentication] to a JSON map.
  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);
}
