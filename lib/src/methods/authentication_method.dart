//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/src/tools/kitsu_client.dart';
import 'package:meta/meta.dart';

/// It contains the only method available for authentication.
class AuthenticationMethod {
  /// This contains the Client that helps connecting to the Kitsu API.
  final KitsuClient _api;

  AuthenticationMethod._(this._api);

  AuthenticationMethod(KitsuClient kitsuClient) : this._(kitsuClient);

  /// Obtain an authentication object via username and password.
  Future<Authentication> viaPasswordGrant(
      {@required String username, @required String password}) async {
    final body = <String, String>{
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    return Authentication.fromJson(await _api.auth(
      body: body,
    ));
  }
}
