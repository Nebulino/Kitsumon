//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It manages a single library entry resource response.
@JsonSerializable(includeIfNull: false)
class LibraryEntryResult
    extends KitsuResponse<LibraryEntry, List<KitsuBaseInclusion>> {
  /// The requested library entry from the request.
  @override
  LibraryEntry? data;

  /// The list of included relationships.
  @override
  List<KitsuBaseInclusion>? included;

  LibraryEntryResult({
    this.data,
    this.included,
  }) : super(
          data: data,
          included: included,
        );

  factory LibraryEntryResult.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryResultFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryEntryResultToJson(this);
}
