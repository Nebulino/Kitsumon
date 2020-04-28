/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsu_methods.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';
import 'package:kitsumon/src/tools/kitsu_client.dart';
import 'package:meta/meta.dart';

class Kitsu {
  final KitsuClient _client;
  final Authentication _authentication;

  Kitsu._(this._client, this._authentication);

  /// It creates a Kitsu Session without authenticating.
  Kitsu.noAuth({String proxy}) : this._(KitsuClient(proxy: proxy), null);

  /// It creates a Kitsu Session with authentication.
  static Future<Kitsu> authenticate({
    @required String username,
    @required String password,
    String proxy,
  }) async {
    var authentication =
        await AuthenticationMethod(KitsuClient(proxy: proxy)).viaPasswordGrant(
      username: username,
      password: password,
    );

    return Kitsu._(KitsuClient(proxy: proxy), authentication);
  }

  /// It returns if You're authenticated or not.
  bool get authenticated => _authentication == null ? false : true;

  /// It returns the client.
  KitsuClient get client => _client;

  /// It returns the authentication object if authenticated.
  Authentication get authentication => authenticated == true
      ? _authentication
      : Future.error(
          KitsumonException(description: "You're not authenticated."));
}
