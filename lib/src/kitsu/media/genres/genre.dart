//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the genre object.
@JsonSerializable(includeIfNull: false)
class Genre extends KitsuBaseObject<GenreAttributes, Map<String, KitsuRelation>> {
  /// It's the ID of a genre.
  @override
  int? id;

  /// It indicates the type, in this case is *genres*.
  @override
  String? type;

  /// It contains the link of the genre inside the api.
  @override
  String? link;

  /// It contains the attributes of the genre.
  @override
  GenreAttributes? attributes;

  /// It contains the possible relationships with the genre.
  @override
  Map<String, KitsuRelation>? relationships;

  Genre({
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

  factory Genre.fromJson(Map<String, dynamic> json) =>
      _$GenreFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
