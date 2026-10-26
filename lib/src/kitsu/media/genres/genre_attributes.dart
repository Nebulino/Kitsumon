//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a genre.
@JsonSerializable(includeIfNull: false)
class GenreAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The name of the genre.
  @JsonKey(name: 'name')
  String? name;

  /// The text-like identifier.
  @JsonKey(name: 'slug')
  String? slug;

  /// The description of the genre.
  @JsonKey(name: 'description')
  String? description;

  GenreAttributes({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.slug,
    this.description,
  });

  factory GenreAttributes.fromJson(Map<String, dynamic> json) =>
      _$GenreAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$GenreAttributesToJson(this);
}
