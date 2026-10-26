//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This object contains the manga title in different languages when available.
@JsonSerializable(includeIfNull: false)
class MangaTitle {
  /// The english version of the manga title.
  @JsonKey(name: 'en')
  String? english;

  /// The american english version of the manga title.
  @JsonKey(name: 'en_us')
  String? americanEnglish;

  /// The japanese version written using english characters of the manga title.
  @JsonKey(name: 'en_jp')
  String? japaneseRomaji;

  /// The japanese version of the manga title.
  @JsonKey(name: 'ja_jp')
  String? japanese;

  /// The korean version of the manga title.
  @JsonKey(name: 'ko_kr')
  String? korean;

  /// The chinese version of the manga title.
  @JsonKey(name: 'zh_cn')
  String? chinese;

  MangaTitle({
    this.english,
    this.americanEnglish,
    this.japaneseRomaji,
    this.japanese,
    this.korean,
    this.chinese,
  });

  /// Convenience alias for [english].
  String? get en => english;

  /// Convenience alias for [americanEnglish].
  String? get enUs => americanEnglish;

  /// Convenience alias for [japaneseRomaji].
  String? get enJp => japaneseRomaji;

  /// Convenience alias for [japanese].
  String? get jaJp => japanese;

  /// Convenience alias for [korean].
  String? get koKr => korean;

  /// Convenience alias for [chinese].
  String? get zhCn => chinese;

  factory MangaTitle.fromJson(Map<String, dynamic> json) =>
      _$MangaTitleFromJson(json);

  Map<String, dynamic> toJson() => _$MangaTitleToJson(this);
}
