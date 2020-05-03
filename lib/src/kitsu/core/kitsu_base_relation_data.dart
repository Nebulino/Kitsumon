/**
 * Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart.
 * Copyright (c) 2020 Nebulino
 */

part of kitsu_objects;

/// This contains some data about the relation between two [KitsuBaseObjects].
///
/// [KitsuBaseObjects]: [KitsuBaseObject]
@JsonSerializable(includeIfNull: false)
class KitsuBaseRelationData {
  // TODO: it's a enum?
  /// This is the type of the Kitsu base object.
  @JsonKey(name: 'type')
  String type;

  /// It's the ID.
  @JsonKey(name: 'id', fromJson: KitsuValueNormalizer.StringToInt)
  int id;

  KitsuBaseRelationData({
    this.type,
    this.id,
  });

  factory KitsuBaseRelationData.fromJson(Map<String, dynamic> json) =>
      _$KitsuBaseRelationDataFromJson(json);

  Map<String, dynamic> toJson() => _$KitsuBaseRelationDataToJson(this);
}
