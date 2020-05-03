/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This object contains the anime title in different languages when available.
@JsonSerializable(includeIfNull: false)
class AnimeTitle {
  /// The english version of the anime title.
  @JsonKey(name: 'en')
  String english;

  /// The japanese version written using english characters of the anime title.
  @JsonKey(name: 'en_jp')
  String japanese_romaji;

  /// The japanese version of the anime title.
  @JsonKey(name: 'ja_jp')
  String japanese;

  AnimeTitle({
    this.english,
    this.japanese_romaji,
    this.japanese,
  });

  factory AnimeTitle.fromJson(Map<String, dynamic> json) =>
      _$AnimeTitleFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeTitleToJson(this);
}
