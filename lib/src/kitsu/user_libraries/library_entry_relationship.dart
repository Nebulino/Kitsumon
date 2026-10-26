//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a [LibraryEntry].
@JsonSerializable(includeIfNull: false)
class LibraryEntryRelationship {
  /// The user that owns the entry.
  @JsonKey(name: 'user')
  KitsuRelation? user;

  /// The media the entry tracks.
  @JsonKey(name: 'media')
  KitsuRelation? media;

  LibraryEntryRelationship({
    this.user,
    this.media,
  });

  factory LibraryEntryRelationship.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryEntryRelationshipToJson(this);
}
