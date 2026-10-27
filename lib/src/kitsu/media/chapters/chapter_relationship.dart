//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a chapter.
@JsonSerializable(includeIfNull: false)
class ChapterRelationship {
  /// The manga the chapter belongs to.
  @JsonKey(name: 'manga')
  KitsuRelation? manga;

  ChapterRelationship({
    this.manga,
  });

  factory ChapterRelationship.fromJson(Map<String, dynamic> json) =>
      _$ChapterRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterRelationshipToJson(this);
}
