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
import 'package:kitsumon/src/kitsu/media/manga/manga_status.dart';
import 'package:kitsumon/src/kitsu/media/manga/manga_subtype.dart';
import 'package:kitsumon/src/kitsu/user_libraries/library_entry_status.dart';

export 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_role.dart';
export 'package:kitsumon/src/kitsu/media/anime/age_rating.dart';
export 'package:kitsumon/src/kitsu/media/anime/anime_status.dart';
export 'package:kitsumon/src/kitsu/media/anime/anime_subtype.dart';
export 'package:kitsumon/src/kitsu/media/manga/manga_status.dart';
export 'package:kitsumon/src/kitsu/media/manga/manga_subtype.dart';
export 'package:kitsumon/src/kitsu/user_libraries/library_entry_status.dart';

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
part 'package:kitsumon/src/kitsu/general_relations/kitsu_relation.dart';

// // // Authentication // // //

part 'package:kitsumon/src/kitsu/authentication.dart';

// // // Characters & People // // //

// Anime Characters
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_attributes.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_relationship.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_character_result.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/anime_characters/anime_characters_results.dart';

// Characters
part 'package:kitsumon/src/kitsu/characters_and_people/characters/character.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/characters/character_attributes.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/characters/character_relationship.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/characters/character_result.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/characters/character_results.dart';

// People
part 'package:kitsumon/src/kitsu/characters_and_people/people/person.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/people/person_attributes.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/people/person_relationship.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/people/person_result.dart';
part 'package:kitsumon/src/kitsu/characters_and_people/people/person_results.dart';

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
part 'package:kitsumon/src/kitsu/media/anime/anime_result.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime_results.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime_relationship.dart';
part 'package:kitsumon/src/kitsu/media/anime/anime_title.dart';
part 'package:kitsumon/src/kitsu/media/anime/rating_frequencies.dart';

// Manga
part 'package:kitsumon/src/kitsu/media/manga/manga_attributes.dart';
part 'package:kitsumon/src/kitsu/media/manga/manga.dart';
part 'package:kitsumon/src/kitsu/media/manga/manga_result.dart';
part 'package:kitsumon/src/kitsu/media/manga/manga_results.dart';
part 'package:kitsumon/src/kitsu/media/manga/manga_relationship.dart';
part 'package:kitsumon/src/kitsu/media/manga/manga_title.dart';

// Categories
part 'package:kitsumon/src/kitsu/media/categories/category_attributes.dart';
part 'package:kitsumon/src/kitsu/media/categories/category.dart';
part 'package:kitsumon/src/kitsu/media/categories/category_result.dart';
part 'package:kitsumon/src/kitsu/media/categories/category_results.dart';
part 'package:kitsumon/src/kitsu/media/categories/category_relationship.dart';

// Genres
part 'package:kitsumon/src/kitsu/media/genres/genre_attributes.dart';
part 'package:kitsumon/src/kitsu/media/genres/genre.dart';
part 'package:kitsumon/src/kitsu/media/genres/genre_result.dart';
part 'package:kitsumon/src/kitsu/media/genres/genre_results.dart';

// Episodes
part 'package:kitsumon/src/kitsu/media/episodes/episode.dart';
part 'package:kitsumon/src/kitsu/media/episodes/episode_attributes.dart';
part 'package:kitsumon/src/kitsu/media/episodes/episode_relationship.dart';
part 'package:kitsumon/src/kitsu/media/episodes/episode_result.dart';
part 'package:kitsumon/src/kitsu/media/episodes/episode_results.dart';

// Chapters
part 'package:kitsumon/src/kitsu/media/chapters/chapter.dart';
part 'package:kitsumon/src/kitsu/media/chapters/chapter_attributes.dart';
part 'package:kitsumon/src/kitsu/media/chapters/chapter_relationship.dart';
part 'package:kitsumon/src/kitsu/media/chapters/chapter_result.dart';
part 'package:kitsumon/src/kitsu/media/chapters/chapter_results.dart';

// Streaming Links
part 'package:kitsumon/src/kitsu/media/streaming_links/streaming_link.dart';
part 'package:kitsumon/src/kitsu/media/streaming_links/streaming_link_attributes.dart';
part 'package:kitsumon/src/kitsu/media/streaming_links/streaming_link_relationship.dart';
part 'package:kitsumon/src/kitsu/media/streaming_links/streaming_link_result.dart';
part 'package:kitsumon/src/kitsu/media/streaming_links/streaming_link_results.dart';

// Mappings
part 'package:kitsumon/src/kitsu/media/mappings/mapping.dart';
part 'package:kitsumon/src/kitsu/media/mappings/mapping_attributes.dart';
part 'package:kitsumon/src/kitsu/media/mappings/mapping_relationship.dart';
part 'package:kitsumon/src/kitsu/media/mappings/mapping_result.dart';
part 'package:kitsumon/src/kitsu/media/mappings/mapping_results.dart';

// // // Posts // // //

// // // Reactions // // //

// // // Site Announcements // // //

// // // User Libraries // // //

part 'package:kitsumon/src/kitsu/user_libraries/library_entry.dart';
part 'package:kitsumon/src/kitsu/user_libraries/library_entry_attributes.dart';
part 'package:kitsumon/src/kitsu/user_libraries/library_entry_relationship.dart';
part 'package:kitsumon/src/kitsu/user_libraries/library_entry_result.dart';
part 'package:kitsumon/src/kitsu/user_libraries/library_entry_results.dart';

// // // Users // // //

part 'package:kitsumon/src/kitsu/users/user.dart';
part 'package:kitsumon/src/kitsu/users/user_attributes.dart';
part 'package:kitsumon/src/kitsu/users/user_relationship.dart';
part 'package:kitsumon/src/kitsu/users/user_result.dart';
part 'package:kitsumon/src/kitsu/users/user_results.dart';
