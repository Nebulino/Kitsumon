//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/src/tools/kitsu_client.dart';

/// Methods for obtaining and refreshing OAuth2 tokens on Kitsu.
class AuthenticationMethod {
  final KitsuClient _api;

  AuthenticationMethod._(this._api);

  /// Creates an [AuthenticationMethod] backed by [kitsuClient].
  AuthenticationMethod(KitsuClient kitsuClient) : this._(kitsuClient);

  /// Obtains an [Authentication] token bundle using the resource-owner password
  /// credentials grant (`grant_type=password`).
  Future<Authentication> viaPasswordGrant({
    required String username,
    required String password,
  }) async {
    final body = <String, String>{
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    return _parseAuthentication(await _api.auth(body: body));
  }

  /// Obtains a fresh [Authentication] token bundle from [refreshToken] using
  /// the refresh-token grant (`grant_type=refresh_token`).
  Future<Authentication> refresh({
    required String refreshToken,
  }) async {
    final body = <String, String>{
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };

    return _parseAuthentication(await _api.auth(body: body));
  }

  Authentication _parseAuthentication(dynamic response) {
    final dynamic decoded =
        (response is String) ? jsonDecode(response) : response;
    return Authentication.fromJson(decoded as Map<String, dynamic>);
  }
}
