//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single user resource response.
@JsonSerializable(includeIfNull: false)
class UserResult extends KitsuResponse<User, List<KitsuBaseInclusion>> {
  /// The requested user from the request.
  @override
  User? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  UserResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory UserResult.fromJson(Map<String, dynamic> json) =>
      _$UserResultFromJson(json);

  Map<String, dynamic> toJson() => _$UserResultToJson(this);
}
