//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single character resource response.
@JsonSerializable(includeIfNull: false)
class CharacterResult extends KitsuResponse<Character, List<KitsuBaseInclusion>> {
  /// The requested character from the request.
  @override
  Character? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  CharacterResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory CharacterResult.fromJson(Map<String, dynamic> json) =>
      _$CharacterResultFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterResultToJson(this);
}
