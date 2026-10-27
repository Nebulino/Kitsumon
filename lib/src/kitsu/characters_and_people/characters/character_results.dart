//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of character resources response.
///
/// A response holding a single character resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class CharacterResults
    extends KitsuResponse<List<Character>, List<KitsuBaseInclusion>> {
  /// The list of characters from the request.
  @override
  @JsonKey(fromJson: _characterListFromJson)
  List<Character>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  CharacterResults({
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

  factory CharacterResults.fromJson(Map<String, dynamic> json) =>
      _$CharacterResultsFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterResultsToJson(this);
}

List<Character>? _characterListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Character.fromJson).toList();
