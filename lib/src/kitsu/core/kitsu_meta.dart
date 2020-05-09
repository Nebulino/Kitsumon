//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This object adds information from a [KitsuResponse].
@JsonSerializable(includeIfNull: false)
class KitsuMeta {
  /// It count the number of data inside [KitsuResponse.data] variable.
  @JsonKey(name: 'count')
  int count;

  KitsuMeta({
    this.count,
  });

  factory KitsuMeta.fromJson(Map<String, dynamic> json) =>
      _$KitsuMetaFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuMetaToJson(this);
}
