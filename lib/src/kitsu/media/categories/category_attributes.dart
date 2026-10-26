//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a category.
@JsonSerializable(includeIfNull: false)
class CategoryAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The title of the category.
  @JsonKey(name: 'title')
  String? title;

  /// The text-like identifier.
  @JsonKey(name: 'slug')
  String? slug;

  /// The description of the category.
  @JsonKey(name: 'description')
  String? description;

  /// The number of media tagged with the category.
  @JsonKey(name: 'totalMediaCount')
  int? totalMediaCount;

  /// The number of child categories.
  @JsonKey(name: 'childCount')
  int? childCount;

  /// True if is not safe for work.
  @JsonKey(name: 'nsfw')
  bool? nsfw;

  CategoryAttributes({
    this.createdAt,
    this.updatedAt,
    this.title,
    this.slug,
    this.description,
    this.totalMediaCount,
    this.childCount,
    this.nsfw,
  });

  factory CategoryAttributes.fromJson(Map<String, dynamic> json) =>
      _$CategoryAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryAttributesToJson(this);
}
