//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  print('--- Searching Anime by title ---');
  final searchResults = await kitsumon.media.anime.fetchCollection(
    text: 'Cowboy Bebop',
    pagination: Pagination(limit: 2),
  );

  for (final anime in searchResults.data ?? <Anime>[]) {
    print('ID: ${anime.id}');
    print('Title: ${anime.attributes?.canonicalTitle}');
    print('Subtype: ${anime.attributes?.subtype?.name}');
    print('Status: ${anime.attributes?.status?.name}');
    print('Rating: ${anime.attributes?.averageRating}');
    print('Episodes: ${anime.attributes?.episodeCount}');
    print('Slug: ${anime.attributes?.slug}');
    print('---');
  }

  print('\n--- Fetching single Anime by Slug ---');
  final bebop = await kitsumon.media.anime.fetchBySlug('cowboy-bebop');
  if (bebop != null) {
    print('Found: ${bebop.attributes?.canonicalTitle}');
    print('Synopsis: ${bebop.attributes?.synopsis?.substring(0, 100)}...');
  }

  print('\n--- Fetching Trending Anime ---');
  final trending = await kitsumon.media.anime.fetchTrending(
    pagination: Pagination(limit: 3),
  );
  for (final anime in trending.data ?? <Anime>[]) {
    print('# Trending: ${anime.attributes?.canonicalTitle}');
  }
}
