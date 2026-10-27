//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the chapter object.
@JsonSerializable(includeIfNull: false)
class Chapter extends KitsuBaseObject<ChapterAttributes, ChapterRelationship> {
  /// It's the ID of a chapter.
  @override
  int? id;

  /// It indicates the type, in this case is *chapters*.
  @override
  String? type;

  /// It contains the link of the chapter inside the api.
  @override
  String? link;

  /// It contains the attributes of the chapter.
  @override
  ChapterAttributes? attributes;

  /// It contains the possible relationships with the chapter.
  @override
  ChapterRelationship? relationships;

  Chapter({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  }) : super(
          id: id,
          type: type,
          link: link,
          attributes: attributes,
          relationships: relationships,
        );

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
