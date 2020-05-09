//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This represent a Kitsu base object.
class KitsuBaseObject<Attributes, Relationships> extends KitsuBaseInclusion {
  /// It's the ID of a Kitsu base object.
  @JsonKey(name: 'id', fromJson: KitsuValueNormalizer.StringToInt)
  int id;

  /// This is the type of the Kitsu base object.
  @override
  @JsonKey(name: 'type')
  String type;

  /// It contains the link of the Kitsu base object inside the api.
  @JsonKey(name: 'links', fromJson: KitsuValueNormalizer.ApiSelfLinkExtractor)
  String link;

  /// It contains the attributes of the Kitsu base object.
  @JsonKey(name: 'attributes')
  Attributes attributes;

  /// It contains the possible relationships with the Kitsu base object.
  @JsonKey(name: 'relationships')
  Relationships relationships;

  KitsuBaseObject({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });
}
