//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/methods/media/anime.dart';

/// It contains all the methods related to Media.
class Media {
  /// This contains the Kitsu Object that helps connecting to the Kitsu API.
  final Kitsu _api;

  late final AnimeMethods _animeMethods;

  Media(this._api) {
    _animeMethods = AnimeMethods(_api);
  }

  /// Use this to access [AnimeMethods].
  AnimeMethods get anime => _animeMethods;
}
