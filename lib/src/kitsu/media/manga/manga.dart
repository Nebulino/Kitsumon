//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the manga object.
@JsonSerializable(includeIfNull: false)
class Manga extends KitsuBaseObject<MangaAttributes, MangaRelationship> {
  /// It's the ID of a manga.
  @override
  int? id;

  /// It indicates the type, in this case is *manga*.
  @override
  String? type;

  /// It contains the link of the manga inside the api.
  @override
  String? link;

  /// It contains the attributes of the manga.
  @override
  MangaAttributes? attributes;

  /// It contains the possible relationships with the manga.
  @override
  MangaRelationship? relationships;

  Manga({
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

  factory Manga.fromJson(Map<String, dynamic> json) =>
      _$MangaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
