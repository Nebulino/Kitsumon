//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the library entry object, the record of a user tracking a media.
@JsonSerializable(includeIfNull: false)
class LibraryEntry
    extends KitsuBaseObject<LibraryEntryAttributes, LibraryEntryRelationship> {
  /// It's the ID of a library entry.
  @override
  int? id;

  /// It indicates the type, in this case is *libraryEntries*.
  @override
  String? type;

  /// It contains the link of the library entry inside the api.
  @override
  String? link;

  /// It contains the attributes of the library entry.
  @override
  LibraryEntryAttributes? attributes;

  /// It contains the possible relationships with the library entry.
  @override
  LibraryEntryRelationship? relationships;

  LibraryEntry({
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

  factory LibraryEntry.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LibraryEntryToJson(this);
}
