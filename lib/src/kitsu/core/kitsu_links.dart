//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This object represents the links variable inside a [KitsuResponse].
@JsonSerializable(includeIfNull: false)
class KitsuLinks {
  /// This is the link of the first [KitsuBaseObject] inside the *data*
  /// variable.
  @JsonKey(name: 'first')
  String? first;

  /// This is the link of the previous page of [KitsuBaseObject]s.
  @JsonKey(name: 'prev')
  String? prev;

  /// This is the link of the next page of [KitsuBaseObject]s.
  @JsonKey(name: 'next')
  String? next;

  /// This is the link of the last [KitsuBaseObject] inside the *data*
  /// variable.
  @JsonKey(name: 'last')
  String? last;

  KitsuLinks({
    this.first,
    this.prev,
    this.next,
    this.last,
  });

  factory KitsuLinks.fromJson(Map<String, dynamic> json) =>
      _$KitsuLinksFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuLinksToJson(this);
}
