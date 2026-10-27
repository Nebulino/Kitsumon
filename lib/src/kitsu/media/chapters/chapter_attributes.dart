//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a chapter.
@JsonSerializable(includeIfNull: false)
class ChapterAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The synopsis of the chapter.
  @JsonKey(name: 'synopsis')
  String? synopsis;

  /// The description of the chapter.
  @JsonKey(name: 'description')
  String? description;

  /// The titles of the chapter keyed by language.
  @JsonKey(name: 'titles')
  Map<String, dynamic>? titles;

  /// The canonical title of the chapter.
  @JsonKey(name: 'canonicalTitle')
  String? canonicalTitle;

  /// The volume number the chapter belongs to.
  @JsonKey(name: 'volumeNumber')
  int? volumeNumber;

  /// The chapter number.
  @JsonKey(name: 'number')
  int? number;

  /// When the chapter was published.
  @JsonKey(name: 'published')
  String? published;

  /// The length of the chapter (page count).
  @JsonKey(name: 'length')
  int? length;

  /// The thumbnail image of the chapter.
  @JsonKey(name: 'thumbnail')
  Map<String, dynamic>? thumbnail;

  ChapterAttributes({
    this.createdAt,
    this.updatedAt,
    this.synopsis,
    this.description,
    this.titles,
    this.canonicalTitle,
    this.volumeNumber,
    this.number,
    this.published,
    this.length,
    this.thumbnail,
  });

  factory ChapterAttributes.fromJson(Map<String, dynamic> json) =>
      _$ChapterAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterAttributesToJson(this);
}
