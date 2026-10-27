//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains the possible relationships of a person.
@JsonSerializable(includeIfNull: false)
class PersonRelationship {
  /// The castings of the person.
  @JsonKey(name: 'castings')
  KitsuRelation? castings;

  /// The staff roles of the person.
  @JsonKey(name: 'staff')
  KitsuRelation? staff;

  /// The voice acting roles of the person.
  @JsonKey(name: 'voices')
  KitsuRelation? voices;

  PersonRelationship({
    this.castings,
    this.staff,
    this.voices,
  });

  factory PersonRelationship.fromJson(Map<String, dynamic> json) =>
      _$PersonRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$PersonRelationshipToJson(this);
}
