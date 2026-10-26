//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of user resources response.
///
/// A response holding a single user resource is read like a collection of one.
@JsonSerializable(includeIfNull: false)
class UserResults extends KitsuResponse<List<User>, List<KitsuBaseInclusion>> {
  /// The list of users from the request.
  @override
  @JsonKey(fromJson: _userListFromJson)
  List<User>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  UserResults({
    this.data,
    this.included,
    this.meta,
    this.links,
  }) : super(
          data: data,
          included: included,
          meta: meta,
          links: links,
        );

  factory UserResults.fromJson(Map<String, dynamic> json) =>
      _$UserResultsFromJson(json);

  Map<String, dynamic> toJson() => _$UserResultsToJson(this);
}

List<User>? _userListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(User.fromJson).toList();
