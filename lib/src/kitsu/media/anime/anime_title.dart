//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This object contains the anime title in different languages when available.
@JsonSerializable(includeIfNull: false)
class AnimeTitle {
  /// The english version of the anime title.
  @JsonKey(name: 'en')
  String? english;

  /// The japanese version written using english characters of the anime title.
  @JsonKey(name: 'en_jp')
  String? japaneseRomaji;

  /// The japanese version of the anime title.
  @JsonKey(name: 'ja_jp')
  String? japanese;

  AnimeTitle({
    this.english,
    this.japaneseRomaji,
    this.japanese,
  });

  // ignore: non_constant_identifier_names
  String? get japanese_romaji => japaneseRomaji;

  /// Convenience alias for [english].
  String? get en => english;

  /// Convenience alias for [japaneseRomaji].
  String? get enJp => japaneseRomaji;

  /// Convenience alias for [japanese].
  String? get jaJp => japanese;

  factory AnimeTitle.fromJson(Map<String, dynamic> json) =>
      _$AnimeTitleFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeTitleToJson(this);
}
