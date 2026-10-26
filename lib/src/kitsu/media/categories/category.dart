//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the category object.
@JsonSerializable(includeIfNull: false)
class Category extends KitsuBaseObject<CategoryAttributes, CategoryRelationship> {
  /// It's the ID of a category.
  @override
  int? id;

  /// It indicates the type, in this case is *categories*.
  @override
  String? type;

  /// It contains the link of the category inside the api.
  @override
  String? link;

  /// It contains the attributes of the category.
  @override
  CategoryAttributes? attributes;

  /// It contains the possible relationships with the category.
  @override
  CategoryRelationship? relationships;

  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
