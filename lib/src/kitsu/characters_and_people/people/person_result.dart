//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single person resource response.
@JsonSerializable(includeIfNull: false)
class PersonResult extends KitsuResponse<Person, List<KitsuBaseInclusion>> {
  /// The requested person from the request.
  @override
  Person? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  PersonResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory PersonResult.fromJson(Map<String, dynamic> json) =>
      _$PersonResultFromJson(json);

  Map<String, dynamic> toJson() => _$PersonResultToJson(this);
}
