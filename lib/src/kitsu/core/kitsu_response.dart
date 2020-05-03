/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This object represents a response from [Kitsu].
///
/// [Kitsu]: https://kitsu.io/
class KitsuResponse<Data, Inclusion> {
  /// Contains the data.
  @JsonKey(name: 'data')
  Data data;

  /// Contains the included data as requested.
  @JsonKey(name: 'included', fromJson: inclusionExtractor)
  Inclusion included;

  /// Contains additional information.
  @JsonKey(name: 'meta')
  KitsuMeta meta;

  /// Contains First and Last link got from [KitsuResponse.data]
  @JsonKey(name: 'links')
  KitsuLinks links;

  KitsuResponse({
    this.data,
    this.included,
    this.meta,
    this.links,
  });
}
