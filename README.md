<h1 align="center">Kitsumon</h1>

<div align="center">
A fox-powered Kitsu.io API wrapper for Dart & Flutter.

[![Pub Version](https://img.shields.io/pub/v/kitsumon?style=flat-square&logo=dart)](https://pub.dev/packages/kitsumon)
[![Dart SDK](https://img.shields.io/badge/Dart-3.0%2B-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Kitsu API](https://img.shields.io/badge/API-Kitsu.io-00aced.svg?style=flat-square)](https://kitsu.docs.apiary.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

</div>

## Meaning

From *Kitsu*, the anime discovery platform, and *Kitsumon* (詰問), which means questioning or asking in Japanese.

Kitsumon is a typed JSON:API client for Kitsu: browsing anime and manga, their episodes, chapters, characters and
staff, plus the authenticated side, the user library you actually track your progress in.

## Installation

```yaml
dependencies:
  kitsumon: ^0.3.0
```

```bash
dart pub add kitsumon
```

## Quick start

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  final anime = await kitsumon.media.anime.fetchResource(1);
  print('${anime.data?.attributes?.canonicalTitle}');
}
```

## Searching anime

Filters, pagination, sorting, includes and sparse fieldsets compose on the same call. A parameter you leave
`null` is not sent at all, so the query stays as small as you asked for.

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  final results = await kitsumon.media.anime.fetchCollection(
    text: 'Cowboy Bebop',
    status: [AnimeStatus.finished],
    pagination: Pagination(limit: 10),
    sorting: Sorting('popularityRank'),
    includes: Includes(['genres']),
    sparseFieldSets: SparseFieldSets('anime', ['canonicalTitle', 'averageRating']),
  );

  for (final anime in results.data ?? <Anime>[]) {
    print('${anime.attributes?.canonicalTitle} (${anime.attributes?.averageRating})');
  }
}
```

Trending anime and trending manga have their own endpoints:

```dart
final trending = await kitsumon.media.trendingManga.fetchTrending();
```

## Manga, episodes, chapters

Every media kind follows the same shape: `fetchCollection`, `fetchResource`, `fetchBySlug`.

```dart
final manga = await kitsumon.media.manga.fetchBySlug('guardian-dog');
final episodes = await kitsumon.media.episodes.fetchCollection(mediaId: 1);
final chapters = await kitsumon.media.chapters.fetchCollection(mangaId: 2);
final links = await kitsumon.media.streamingLinks.fetchCollection(mediaId: 1);
final mappings = await kitsumon.media.mappings.fetchCollection(
  externalSite: 'myanimelist/anime',
  externalId: '1',
);
```

Taxonomies are available too, with typed filters rather than raw maps:

```dart
final categories = await kitsumon.media.categories.fetchCollection(title: 'action');
final genres = await kitsumon.media.genres.fetchCollection(name: 'Drama');
```

## Characters and people

```dart
final character = await kitsumon.charactersAndPeople.characters.fetchBySlug('spike-spiegel');
final person = await kitsumon.charactersAndPeople.people.fetchResource(11614);
```

## Authentication and the user library

Kitsu logs in with an OAuth2 password grant. Kitsumon refreshes the token itself: on a `401` it exchanges the
refresh token once, rewrites the bearer header and replays the request. A second `401` is surfaced as an error
instead of looping.

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsu = await Kitsu.authenticate(
    username: 'you@example.com',
    password: 'your-password',
  );
  final kitsumon = Kitsumon(kitsu: kitsu);

  final me = await kitsumon.users.fetchCurrentUser();
  print('Hello ${me.data?.attributes?.name}');

  // Track a title: only the attributes you pass are sent.
  final entry = await kitsumon.libraryEntries.createResource(
    userId: me.data!.id!,
    mediaId: 1,
    mediaType: 'anime',
    status: LibraryEntryStatus.current,
    progress: 3,
  );

  final updated = await kitsumon.libraryEntries.updateResource(
    entry.data!.id!,
    progress: 12,
    ratingTwenty: 18,
  );

  final mine = await kitsumon.libraryEntries.fetchCollection(
    userId: me.data!.id,
    includeMedia: true,
  );

  await kitsumon.libraryEntries.deleteResource(entry.data!.id!);
  print('${updated.data?.attributes?.typedStatus} ${mine.data?.length}');
}
```

`LibraryEntryStatus` covers `current`, `planned`, `completed`, `onHold` and `dropped`. Kitsu is free to add
values: an unrecognised status is kept as the raw string in `LibraryEntryAttributes.status` and
`typedStatus` returns `null` instead of throwing.

## Proxy

Every `Kitsu` entry point accepts `proxy: 'host:port'`. The proxy is applied on native platforms through
`HttpClient.findProxy`, and TLS certificates stay fully verified. In the browser the proxy belongs to the
browser, so the value is ignored.

## What is implemented

| Area | Methods |
| :--- | :--- |
| Anime | `fetchCollection`, `fetchResource`, `fetchBySlug`, `fetchTrending` |
| Manga | `fetchCollection`, `fetchResource`, `fetchBySlug`, `fetchTrending` |
| Categories, Genres | `fetchCollection`, `fetchResource` |
| Episodes, Chapters | `fetchCollection`, `fetchResource` |
| Streaming links, Mappings | `fetchCollection`, `fetchResource` |
| Characters, People | `fetchCollection`, `fetchResource`, `fetchBySlug` |
| Users | `fetchCollection`, `fetchResource`, `fetchBySlug`, `fetchCurrentUser` |
| Library entries | `fetchCollection`, `fetchResource`, `createResource`, `updateResource`, `deleteResource` |

Social features (posts, comments, reviews, reactions) and groups are on the roadmap, not in this release.

## Development

Regenerate the serialization code after touching an annotated model:

```bash
dart run build_runner build
```

The analyzer must stay free of issues, infos included, and the whole suite runs offline against a fake
`HttpClientAdapter`, so no test ever reaches Kitsu:

```bash
dart analyze --fatal-infos .
dart test
```

## Features and Bugs

Feature requests and bug reports go to the [GitHub issue tracker](https://github.com/Nebulino/Kitsumon/issues).

## License

This project is licensed under the [MIT License](LICENSE).
