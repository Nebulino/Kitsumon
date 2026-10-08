//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// This represents a relation between two [KitsuBaseObjects].
///
/// [KitsuBaseObjects]: [KitsuBaseObject]
class KitsuBaseRelation<Data> {
  /// It contains some links about this relation.
  @JsonKey(name: 'links')
  KitsuRelationshipLinks? links;

  /// It contains some data about this relation.
  @JsonKey(name: 'data')
  Data? data;

  KitsuBaseRelation({
    this.links,
    this.data,
  });
}
