//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// Kitsu Type Class.
library kitsu_objects;

// Packages
import 'package:json_annotation/json_annotation.dart';
import 'package:kitsumon/src/helpers/inclusion_extractor.dart';

// Helpers
import 'package:kitsumon/src/helpers/kitsu_value_normalizer.dart';
import 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_role.dart';
import 'package:kitsumon/src/kitsu/media/anime/age_rating.dart';
import 'package:kitsumon/src/kitsu/media/anime/anime_status.dart';
import 'package:kitsumon/src/kitsu/media/anime/anime_subtype.dart';

// g.dart
part 'kitsu.g.dart';

// Objects
part 'package:kitsumon/src/kitsu/core/kitsu_base_inclusion.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_base_object.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_base_relation.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_base_relation_data.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_links.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_meta.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_response.dart';
part 'package:kitsumon/src/kitsu/core/kitsu_relationship_links.dart';

// General Relation
part 'package:kitsumon/src/kitsu/general_relations/anime_relation.dart';
part 'package:kitsumon/src/kitsu/general_relations/castings_relation.dart';
part 'package:kitsumon/src/kitsu/general_relations/character_relation.dart';

// // // Authentication // // //

part 'package:kitsumon/src/kitsu/authentication.dart';

// // // Characters & People // // //

// Anime Characters
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_attributes.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_relationship.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_result.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_characters_results.dart';

// // // Groups // // //

// // // Media // // //

// Anime
part 'package:kitsumon/src/kitsu/media/anime/image/cover_dimensions.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/cover_image.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/image_dimension.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/meta_cover_images.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/meta_poster_images.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/poster_dimensions.dart';
part 'package:kitsumon/src/kitsu/media/anime/image/poster_image.dart';

part 'package:kitsumon/src/kitsu/media/anime/anime_attributes.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime_relationship.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime_title.dart';
part 'package:kitsumon/src/kitsu/media/anime/rating_frequencies.dart';

// // // Posts // // //

// // // Reactions // // //

// // // Site Announcements // // //

// // // User Libraries // // //

// // // Users // // //
