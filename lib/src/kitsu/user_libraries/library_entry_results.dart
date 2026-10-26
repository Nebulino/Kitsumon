//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a collection of library entry resources response.
@JsonSerializable(includeIfNull: false)
class LibraryEntryResults
    extends KitsuResponse<List<LibraryEntry>, List<KitsuBaseInclusion>> {
  /// The list of library entries from the request.
  @override
  @JsonKey(fromJson: _libraryEntryListFromJson)
  List<LibraryEntry>? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  /// The meta information of the request.
  @override
  KitsuMeta? meta;

  /// The links information of the request.
  @override
  KitsuLinks? links;

  LibraryEntryResults({
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

  factory LibraryEntryResults.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryResultsFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryEntryResultsToJson(this);
}

List<LibraryEntry>? _libraryEntryListFromJson(dynamic data) =>
    KitsuValueNormalizer.resourceList(data)
        ?.map(LibraryEntry.fromJson)
        .toList();
