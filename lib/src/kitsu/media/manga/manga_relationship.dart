//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a manga.
@JsonSerializable(includeIfNull: false)
class MangaRelationship {
  /// The genres of the manga.
  @JsonKey(name: 'genres')
  KitsuRelation? genres;

  /// The categories of the manga.
  @JsonKey(name: 'categories')
  KitsuRelation? categories;

  /// The castings of the manga.
  @JsonKey(name: 'castings')
  KitsuRelation? castings;

  /// The installments of the manga.
  @JsonKey(name: 'installments')
  KitsuRelation? installments;

  /// The mappings of the manga to other databases.
  @JsonKey(name: 'mappings')
  KitsuRelation? mappings;

  /// The reviews of the manga.
  @JsonKey(name: 'reviews')
  KitsuRelation? reviews;

  /// The relationships between this manga and other media.
  @JsonKey(name: 'mediaRelationships')
  KitsuRelation? mediaRelationships;

  /// The characters of the manga.
  @JsonKey(name: 'characters')
  KitsuRelation? characters;

  /// The staff of the manga.
  @JsonKey(name: 'staff')
  KitsuRelation? staff;

  /// The productions of the manga.
  @JsonKey(name: 'productions')
  KitsuRelation? productions;

  /// The quotes of the manga.
  @JsonKey(name: 'quotes')
  KitsuRelation? quotes;

  /// The chapters of the manga.
  @JsonKey(name: 'chapters')
  KitsuRelation? chapters;

  /// The manga characters of the manga.
  @JsonKey(name: 'mangaCharacters')
  KitsuRelation? mangaCharacters;

  /// The manga staff of the manga.
  @JsonKey(name: 'mangaStaff')
  KitsuRelation? mangaStaff;

  MangaRelationship({
    this.genres,
    this.categories,
    this.castings,
    this.installments,
    this.mappings,
    this.reviews,
    this.mediaRelationships,
    this.characters,
    this.staff,
    this.productions,
    this.quotes,
    this.chapters,
    this.mangaCharacters,
    this.mangaStaff,
  });

  factory MangaRelationship.fromJson(Map<String, dynamic> json) =>
      _$MangaRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$MangaRelationshipToJson(this);
}
