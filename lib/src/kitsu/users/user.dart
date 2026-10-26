//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It's the user object.
@JsonSerializable(includeIfNull: false)
class User extends KitsuBaseObject<UserAttributes, UserRelationship> {
  /// It's the ID of a user.
  @override
  int? id;

  /// It indicates the type, in this case is *users*.
  @override
  String? type;

  /// It contains the link of the user inside the api.
  @override
  String? link;

  /// It contains the attributes of the user.
  @override
  UserAttributes? attributes;

  /// It contains the possible relationships with the user.
  @override
  UserRelationship? relationships;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
