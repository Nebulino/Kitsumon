//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a character.
@JsonSerializable(includeIfNull: false)
class CharacterAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The text-like identifier.
  @JsonKey(name: 'slug')
  String? slug;

  /// The character names keyed by language (e.g. `{'en': 'Jet Black'}`).
  @JsonKey(name: 'names')
  Map<String, dynamic>? names;

  /// The canonical name of the character.
  @JsonKey(name: 'canonicalName')
  String? canonicalName;

  /// Other names or aliases of the character.
  @JsonKey(name: 'otherNames')
  List<String>? otherNames;

  /// The name of the character.
  @JsonKey(name: 'name')
  String? name;

  /// The MyAnimeList identifier.
  @JsonKey(name: 'malId')
  dynamic malId;

  /// The description / biography of the character.
  @JsonKey(name: 'description')
  String? description;

  /// The images of the character.
  @JsonKey(name: 'image')
  Map<String, dynamic>? image;

  CharacterAttributes({
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.names,
    this.canonicalName,
    this.otherNames,
    this.name,
    this.malId,
    this.description,
    this.image,
  });

  factory CharacterAttributes.fromJson(Map<String, dynamic> json) =>
      _$CharacterAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterAttributesToJson(this);
}
