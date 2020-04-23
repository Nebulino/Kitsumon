/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';
import 'package:kitsumon/src/tools/kitsu_client.dart';
import 'package:meta/meta.dart';

class AuthenticationMethods {
  final String _methodRadix = '/oauth';
  final KitsuClient _client;

  AuthenticationMethods(this._client);

  Future<Authentication> viaPasswordGrant(
      {@required String username, @required String password}) async {
    final body = <String, String>{
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    return Authentication.fromJson(await _client.post(
      method: '${_methodRadix}/token',
      body: body,
    ));
  }
}
