//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the person object.
@JsonSerializable(includeIfNull: false)
class Person extends KitsuBaseObject<PersonAttributes, PersonRelationship> {
  /// It's the ID of a person.
  @override
  int? id;

  /// It indicates the type, in this case is *people*.
  @override
  String? type;

  /// It contains the link of the person inside the api.
  @override
  String? link;

  /// It contains the attributes of the person.
  @override
  PersonAttributes? attributes;

  /// It contains the possible relationships with the person.
  @override
  PersonRelationship? relationships;

  Person({
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

  factory Person.fromJson(Map<String, dynamic> json) =>
      _$PersonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
