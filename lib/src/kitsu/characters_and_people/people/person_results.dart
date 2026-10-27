//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of person resources response.
///
/// A response holding a single person resource is read like a collection of
/// one.
@JsonSerializable(includeIfNull: false)
class PersonResults
    extends KitsuResponse<List<Person>, List<KitsuBaseInclusion>> {
  /// The list of people from the request.
  @override
  @JsonKey(fromJson: _personListFromJson)
  List<Person>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request, absent from some endpoints.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  PersonResults({
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

  factory PersonResults.fromJson(Map<String, dynamic> json) =>
      _$PersonResultsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonResultsToJson(this);
}

List<Person>? _personListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)?.map(Person.fromJson).toList();
