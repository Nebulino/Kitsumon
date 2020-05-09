//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

part of kitsu_objects;

/// This contains different rating frequencies.
@JsonSerializable(includeIfNull: false)
class RatingFrequencies {
  @JsonKey(name: '2')
  String $2;

  @JsonKey(name: '3')
  String $3;

  @JsonKey(name: '4')
  String $4;

  @JsonKey(name: '5')
  String $5;

  @JsonKey(name: '6')
  String $6;

  @JsonKey(name: '7')
  String $7;

  @JsonKey(name: '8')
  String $8;

  @JsonKey(name: '9')
  String $9;

  @JsonKey(name: '10')
  String $10;

  @JsonKey(name: '11')
  String $11;

  @JsonKey(name: '12')
  String $12;

  @JsonKey(name: '13')
  String $13;

  @JsonKey(name: '14')
  String $14;

  @JsonKey(name: '15')
  String $15;

  @JsonKey(name: '16')
  String $16;

  @JsonKey(name: '17')
  String $17;

  @JsonKey(name: '18')
  String $18;

  @JsonKey(name: '19')
  String $19;

  @JsonKey(name: '20')
  String $20;

  RatingFrequencies({
    this.$2,
    this.$3,
    this.$4,
    this.$5,
    this.$6,
    this.$7,
    this.$8,
    this.$9,
    this.$10,
    this.$11,
    this.$12,
    this.$13,
    this.$14,
    this.$15,
    this.$16,
    this.$17,
    this.$18,
    this.$19,
    this.$20,
  });

  factory RatingFrequencies.fromJson(Map<String, dynamic> json) =>
      _$RatingFrequenciesFromJson(json);

  Map<String, dynamic> toJson() => _$RatingFrequenciesToJson(this);
}
