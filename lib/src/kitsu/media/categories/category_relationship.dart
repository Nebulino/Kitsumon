//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a category.
@JsonSerializable(includeIfNull: false)
class CategoryRelationship {
  /// The parent category.
  @JsonKey(name: 'parent')
  KitsuRelation? parent;

  /// The anime tagged with the category.
  @JsonKey(name: 'anime')
  KitsuRelation? anime;

  /// The drama tagged with the category.
  @JsonKey(name: 'drama')
  KitsuRelation? drama;

  /// The manga tagged with the category.
  @JsonKey(name: 'manga')
  KitsuRelation? manga;

  CategoryRelationship({
    this.parent,
    this.anime,
    this.drama,
    this.manga,
  });

  factory CategoryRelationship.fromJson(Map<String, dynamic> json) =>
      _$CategoryRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryRelationshipToJson(this);
}
