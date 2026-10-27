<h1 align="center">Kitsumon</h1>

<div align="center">
A fox-powered Kitsu.io API wrapper for Dart & Flutter.

[![Pub Version](https://img.shields.io/pub/v/kitsumon?style=flat-square&logo=dart)](https://pub.dev/packages/kitsumon)
[![Dart SDK](https://img.shields.io/badge/Dart-3.0%2B-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Kitsu API](https://img.shields.io/badge/API-Kitsu.io-00aced.svg?style=flat-square)](https://kitsu.docs.apiary.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

</div>

---

## Meaning

From *Kitsu*, the anime discovery platform, and *Kitsumon* (詰問), which means questioning or asking in Japanese.

If you love Kitsu.io and want a clean, typed way of querying their API for anime, manga, and characters, Kitsumon is made for you!

---

## Installation

Add `kitsumon` to your `pubspec.yaml`:

```yaml
dependencies:
  kitsumon: ^0.2.0
```

Or via terminal:

```bash
dart pub add kitsumon
```

---

## Usage

### 1. Basic Initialization

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  // Unauthenticated client
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  // Or with credentials (when supported)
  // final kitsumon = Kitsumon(kitsu: Kitsu(auth: KitsuAuth(...)));
}
```

### 2. Fetching Anime Collections with Filters

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  // Fetch anime by text search, season, or category
  final result = await kitsumon.media.anime.fetchCollection(
    text: 'Cowboy Bebop',
    pageLimit: 10,
    sort: [Sort.popularityRankAscending],
  );

  for (final anime in result.data ?? []) {
    print('${anime.attributes?.canonicalTitle} (Rating: ${anime.attributes?.averageRating})');
  }
}
```

### 3. Fetching Anime Characters & Details

```dart
import 'package:kitsumon/kitsumon.dart';

void main() async {
  final kitsumon = Kitsumon(kitsu: Kitsu.noAuth());

  // Fetch anime character details
  final characterResponse = await kitsumon.charactersAndPeople.animeCharacters.fetchResource(
    11614,
    includes: Includes(['anime']),
    sparseFieldSets: SparseFieldSets('anime', ['canonicalTitle', 'createdAt']),
  );

  print('Role: ${characterResponse.data?.attributes?.role}');
}
```

---

## Building from Source

To regenerate `.g.dart` serialization code:

```bash
sh ./build.sh
```

Or directly via `build_runner`:

```bash
dart run build_runner build
```


---

## Features and Bugs

Please file feature requests and bug reports on the [GitHub Issue Tracker](https://github.com/Nebulino/Kitsumon/issues).

---

## License

This project is licensed under the [MIT License](LICENSE).
