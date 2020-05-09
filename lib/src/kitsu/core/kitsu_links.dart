//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This object represents the links variable inside a [KitsuResponse].
@JsonSerializable(includeIfNull: false)
class KitsuLinks {
  // TODO: transform in URI?
  /// This is the link of the first [KitsuBaseObject] inside the *data*
  /// variable.
  @JsonKey(name: 'first')
  String first;

  // TODO: transform in URI?
  /// This is the link of the last [KitsuBaseObject] inside the *data*
  /// variable.
  @JsonKey(name: 'last')
  String last;

  KitsuLinks({
    this.first,
    this.last,
  });

  factory KitsuLinks.fromJson(Map<String, dynamic> json) =>
      _$KitsuLinksFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuLinksToJson(this);
}
