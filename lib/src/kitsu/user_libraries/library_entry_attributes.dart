//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of 'package:kitsumon/src/kitsu.dart';

/// It contains all the attributes of a [LibraryEntry].
///
/// [ratingTwenty] is the rating on Kitsu's 2-to-20 scale (so `20` is five
/// stars); the API also reports it as `rating` in some payloads, which is not
/// modelled here.
@JsonSerializable(includeIfNull: false)
class LibraryEntryAttributes {
  /// The raw status the API sent, kept as-is so an unknown value survives.
  @JsonKey(name: 'status')
  String? status;

  /// How many episodes (anime) or chapters (manga) the user has seen or read.
  @JsonKey(name: 'progress')
  int? progress;

  /// When the progress was last updated.
  @JsonKey(name: 'progressedAt')
  DateTime? progressedAt;

  /// The rating on a 2-to-20 scale.
  @JsonKey(name: 'ratingTwenty')
  int? ratingTwenty;

  /// Whether the user is re-consuming the media.
  @JsonKey(name: 'reconsuming')
  bool? reconsuming;

  /// How many times the user re-consumed the media.
  @JsonKey(name: 'reconsumeCount')
  int? reconsumeCount;

  /// The notes the user attached to the entry.
  @JsonKey(name: 'notes')
  String? notes;

  /// Whether the entry is private.
  @JsonKey(name: 'private')
  bool? private;

  /// When the user started the media.
  @JsonKey(name: 'startedAt')
  DateTime? startedAt;

  /// When the user finished the media.
  @JsonKey(name: 'finishedAt')
  DateTime? finishedAt;

  /// When the entry was created.
  @JsonKey(name: 'createdAt')
  DateTime? createdAt;

  /// When the entry was last updated.
  @JsonKey(name: 'updatedAt')
  DateTime? updatedAt;

  LibraryEntryAttributes({
    this.status,
    this.progress,
    this.progressedAt,
    this.ratingTwenty,
    this.reconsuming,
    this.reconsumeCount,
    this.notes,
    this.private,
    this.startedAt,
    this.finishedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// The status as a typed value, or `null` when Kitsu sent one this package
  /// does not know. The raw value stays in [status].
  LibraryEntryStatus? get typedStatus => LibraryEntryStatus.parse(status);

  /// The rating on a 1-to-5 star scale, or `null` when unrated.
  double? get rating => ratingTwenty == null ? null : ratingTwenty! / 4;

  factory LibraryEntryAttributes.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryEntryAttributesToJson(this);
}
