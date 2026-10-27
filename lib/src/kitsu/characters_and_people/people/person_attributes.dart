//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the attributes of a person.
@JsonSerializable(includeIfNull: false)
class PersonAttributes {
  /// The date of creation of the entry.
  @JsonKey(name: 'createdAt')
  String? createdAt;

  /// The date of update of the entry.
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  /// The name of the person.
  @JsonKey(name: 'name')
  String? name;

  /// The MyAnimeList identifier or migration message.
  @JsonKey(name: 'malId')
  dynamic malId;

  /// The description / biography of the person.
  @JsonKey(name: 'description')
  String? description;

  /// The images of the person.
  @JsonKey(name: 'image')
  Map<String, dynamic>? image;

  PersonAttributes({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.malId,
    this.description,
    this.image,
  });

  factory PersonAttributes.fromJson(Map<String, dynamic> json) =>
      _$PersonAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$PersonAttributesToJson(this);
}
