//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsu_methods.dart';
import 'package:kitsumon/src/tools/kitsu_client.dart';

class Kitsu {
  final KitsuClient _client;
  final Authentication? _authentication;

  Kitsu._(this._client, this._authentication);

  /// It creates a Kitsu Session without authenticating.
  Kitsu.noAuth({String? proxy}) : this._(KitsuClient(proxy: proxy), null);

  /// It creates a Kitsu Session with a custom [KitsuClient] (useful for testing or custom configurations).
  Kitsu.withClient(KitsuClient client, [Authentication? authentication])
      : this._(client, authentication);

  /// It creates a Kitsu Session with authentication.
  static Future<Kitsu> authenticate({
    required String username,
    required String password,
    String? proxy,
  }) async {
    final authentication =
        await AuthenticationMethod(KitsuClient(proxy: proxy)).viaPasswordGrant(
      username: username,
      password: password,
    );

    return Kitsu._(
      KitsuClient(
        authentication: authentication,
        proxy: proxy,
        onUnauthorized: () => _refreshAuthentication(
          AuthenticationMethod(KitsuClient(proxy: proxy)),
          authentication,
        ),
      ),
      authentication,
    );
  }

  /// Exchanges the refresh token of [expired] for a fresh [Authentication].
  ///
  /// It returns `null` when [expired] carries no refresh token, which makes
  /// the client surface the original 401 instead of retrying.
  static Future<Authentication?> _refreshAuthentication(
    AuthenticationMethod method,
    Authentication? expired,
  ) async {
    final refreshToken = expired?.refreshToken;
    if (refreshToken == null) {
      return null;
    }
    return method.refresh(refreshToken: refreshToken);
  }

  /// It returns if You're authenticated or not.
  bool get authenticated => _authentication != null;

  /// It returns the client.
  KitsuClient get client => _client;

  /// It returns the authentication object if authenticated.
  Authentication? get authentication => _authentication;

  /// Use this to access the [UsersMethods] of this session.
  UsersMethods get users => UsersMethods(this);

  /// Use this to access the [LibraryEntriesMethods] of this session.
  LibraryEntriesMethods get libraryEntries => LibraryEntriesMethods(this);
}
