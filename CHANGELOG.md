## Unreleased

- Implemented Phase 3 of the roadmap (Media Extensions / Child Resources, Characters & People):
  - `EpisodesMethods` (`fetchCollection` supporting `mediaType`, `mediaId`, `number`, `seasonNumber`, `fetchResource`) over `/edge/episodes`, with models `Episode`, `EpisodeAttributes`, `EpisodeResults`, `EpisodeResult`, and `EpisodeRelationship`.
  - `ChaptersMethods` (`fetchCollection` supporting `mangaId`, `number`, `volumeNumber`, `fetchResource`) over `/edge/chapters`, with models `Chapter`, `ChapterAttributes`, `ChapterResults`, `ChapterResult`, and `ChapterRelationship`.
  - `StreamingLinksMethods` (`fetchCollection` supporting `mediaType`, `mediaId`, `streamerId`, `fetchResource`) over `/edge/streaming-links`, with models `StreamingLink`, `StreamingLinkAttributes`, `StreamingLinkResults`, `StreamingLinkResult`, and `StreamingLinkRelationship`.
  - `MappingsMethods` (`fetchCollection` supporting `externalSite`, `externalId`, `itemId`, `itemType`, `fetchResource`) over `/edge/mappings`, with models `Mapping`, `MappingAttributes`, `MappingResults`, `MappingResult`, and `MappingRelationship`.
  - `CharactersMethods` (`fetchCollection` supporting `name`, `slug`, `malId`, `fetchResource`, `fetchBySlug`) over `/edge/characters`, with models `Character`, `CharacterAttributes`, `CharacterResults`, `CharacterResult`, and `CharacterRelationship`.
  - `PeopleMethods` (`fetchCollection` supporting `name`, `slug`, `malId`, `fetchResource`, `fetchBySlug`) over `/edge/people`, with models `Person`, `PersonAttributes`, `PersonResults`, `PersonResult`, and `PersonRelationship`.
  - Exposed the new methods on `Media` (`kitsumon.media.episodes`, `kitsumon.media.chapters`, `kitsumon.media.streamingLinks`, `kitsumon.media.mappings`) and `CharactersAndPeople` (`kitsumon.charactersAndPeople.characters`, `kitsumon.charactersAndPeople.people`), and exported them via `lib/kitsu_methods.dart`.
  - Added unit test suites for all 6 new method groups in `test/media/` and `test/characters_and_people/` with real API fixture payloads.

- `KitsuClient` now registers the same interceptor stack on a `Dio` you inject
  as on one it builds itself: null query/body parameters are stripped, timeouts
  surface as a `KitsumonException` (as the `DioException.error`) and JSON:API
  `errors[]` payloads surface as an `ApiException`. For an injected `Dio` only
  the missing `baseUrl`, `Accept`/`Content-Type` and `Authorization` values are
  filled in; anything you configured is left untouched. Registration is
  idempotent: wrapping the same `Dio` in several clients adds the interceptor
  once. **Behaviour change:** clients built with `KitsuClient(dio: ...)` used to
  skip all of this.
- TLS certificates are now always verified. Using a `proxy` no longer installs a
  `badCertificateCallback` that accepted any certificate for any host; the proxy
  is still configured through `HttpClient.findProxy`. **Behaviour change:**
  proxies that relied on certificate errors being ignored will now fail the
  handshake.
- Added an offline test harness (`test/support/fake_http_client.dart`): a `dio`
  `HttpClientAdapter` that records requests and answers from canned JSON:API
  payloads, plus helpers to build a `Kitsu`/`KitsuClient` around it.
- Added tests for `KitsuClient` (GET/POST shapes, headers, bearer token,
  timeouts, `errors[]`, injected `Dio`, proxy), `Request`, `Filter`,
  `Pagination`, `Sorting`, `Includes`, `SparseFieldSets`, `KitsuValueNormalizer`,
  `inclusionExtractor`, the JSON:API models (`KitsuResponse`, `KitsuBaseObject`,
  relations, `Authentication`), `AuthenticationMethod` and the `Kitsumon`
  aggregator entry points.
- CI now runs `dart analyze --fatal-infos .` over the whole repository,
  `example/` included.
- Implemented Phase 2 of the roadmap, the tracing core:
  - `UsersMethods` (`fetchCollection` with `filter[name]`/`filter[slug]`, `fetchResource`, `fetchBySlug`,
    `fetchCurrentUser` via `filter[self]=true`) and the `User` model with all 33 attributes Kitsu returns.
  - `LibraryEntriesMethods`: `fetchCollection` (user, media type, kind, statuses, `include=media`),
    `fetchResource`, `createResource`, `updateResource` and `deleteResource`, all speaking JSON:API
    documents; every write refuses with a `KitsumonException` and sends nothing when the session is not
    authenticated.
  - `LibraryEntry` / `LibraryEntryAttributes` with `typedStatus` (an unknown status is kept raw and never
    throws) and `rating`, derived from Kitsu's `ratingTwenty`.
  - `KitsuClient.post`/`patch`/`delete` now behave like `get` and prefix `/edge/`; `patch` and `delete`
    replace the "Not Yet Implemented" stubs.
  - OAuth refresh: `Authentication.tokenType` reads `token_type` (it was always null before), `isExpired`
    compares `created_at + expires_in` with a 30 s margin, `AuthenticationMethod.refresh` uses the
    refresh-token grant, and a 401 refreshes once, rewrites the bearer header and replays the request once
    — a second 401 surfaces the original error instead of looping.
- Fixed: `toJson()` now writes `links` in the object form `fromJson` reads back, so a round-trip no longer
  throws; `Anime.relationships` is parsed instead of being dropped, and an unknown relationship type no
  longer fails a whole response.
- Implemented the rest of Phase 1 of the roadmap:
  - `MangaMethods` (`fetchCollection`, `fetchResource`, `fetchBySlug`) over `/edge/manga`, with typed
    filters for subtype, status, categories, genres, ids and slug, plus sorting, pagination, includes and
    sparse fieldsets.
  - `TrendingMangaMethods.fetchTrending()` over `/edge/trending/manga`, tolerating an answer without a
    `meta` block.
  - `CategoriesMethods` and `GenresMethods` (`fetchCollection`, `fetchResource`) with typed
    `filter[title]`/`filter[slug]`/`filter[name]` parameters and their `Category`/`Genre` models,
    including the boolean `nsfw` and the child/media counters.
  - New models mirroring the real API: `Manga`, `MangaAttributes` (all 29 attributes, nullable counts and
    dates, `averageRating` kept as the string Kitsu sends), `MangaResults`, `MangaRelationship`,
    `MangaSubtype`, `MangaStatus`, `Category`, `CategoryAttributes`, `Genre`, `GenreAttributes`.
  - `Media` now exposes `manga`, `trendingManga`, `categories` and `genres` next to `anime`.
  - Tests for all of it, driven by three responses captured from the live API and stored under
    `test/fixtures/`, asserting both the request sent and the model parsed.

## 0.2.1

- Set up automated publishing to pub.dev via GitHub Actions (OIDC) with a
  release gate on the `publish` branch.

## 0.2.0

- Migrated to Dart 3 sound null safety with modern SDK constraint.
- Upgraded dependencies: Dio 5.7, json_annotation 4.9, crypto 3.0.6.
- Implemented and wired full Anime methods (`fetchResource`, `fetchCollection`, `fetchBySlug`, `fetchTrending`).
- Added typed sorting, pagination, sparse fieldsets, and includes helpers.
- Added comprehensive unit tests and example scripts.

## 0.1.1

- Updated Copyright headline for a bump to Dart 2.8.0.
- Updated the README.md.
- Updated the pubspec.yaml.


## 0.1.0
### Still working in some aspects of the Wrapper, but some decided structures are *online**.

- Fixing the **README.md** again.
- Created **Age Rating** object.
- Created **Anime** object.
- Created **Anime Attributes** object.
- Created **Anime Character** object.
- Created **Anime Character Attributes** object.
- Created **Anime Character Relationship** object.
- Created **Anime Character Result** object.
- Created **Anime Character Result** object.
- Moved **Anime Character Role** enum.
- Modified the implementation of some **Anime Characters** methods.
- Created **Anime Characters Results** object.
- Moved **Anime Production Role** enum for future use.
- Created **Anime Relation** object.
- Created **Anime Relationship** object, but it's a place holder.
- Created **Anime Status** enum.
- Created **Anime Subtype** enum.
- Created **Anime Title** object.
- Added some documentation in **ApiException** object.
- Added some documentation in **AuthenticationMethod**.
- Created **Castings Relation** object.
- Created **Character Relation** object.
- Added some documentation in **CharactersAndPeople** methods.
- Created Objects related with the **Poster** and **Cover images** of an *anime*.
- Added some documentation in **Filter** object.
- Added some documentation in **Includes** object.
- Created a helper that helps extract the *includes* objects from a *request*.
- Added some documentation in **Filter** object.
- Created important base **Kitsu objects**.
- Modified the **KitsuClient**, now it returns a Map object.
- More **Kitsu Value Normalizer functions**.
- Added some documentation in **Pagination** object.
- Created **RatingFrequencies** object.
- Added some documentation in **Request** object.
- Added async on get() in **Filter** object.
- Added some documentation in **Sorting** object.
- Added some documentation in **SparseFieldSets** object.
- Created a new usage *example*.
- Still, need to implement lots of part, even on some already create objects.

## 0.0.3
### Still working at the base implementation of Kitsumon

- Fixing the **README.md**.
- Created **AnimeCharacterRole** enum.
- Created **AnimeProductionRole** enum.
- Simplified the **AuthenticationMethod**.
- Created **BaseMethod** for other methods.
- Initial implementation of **AnimeCharactersMethods**.
    > *Lots of work* to do such as stating thinking the stucture.
- Created **CharactersAndPeople** *group* of methods.
- Created **Filter** object.
- Created **Includes** object.
- Fixed **Kitsu** object after *AuthenticationMethod* simplification.
- Fixed **KitsuClient** object to obtain only the *first error*.
- Added new **AnimeCharactersMethods** on methods' library.
- Added a direct caller on Kitsumon for **AnimeCharactersMethods**.
- Started writing an example to help find:
    > *The easiest way* to use this wrapper.
    > Errors while writing the wrapper.
- Fixed* Kitsumon exceptions* library name.
- Fixed **Pagination** object for better interaction with **Request** object.
- Created **Request** object that helps to route different type of API request methods.
    > For now is implemented a starting point for *GET* *POST* *AUTH*
- Fixed **Sorting** object for better interaction with **Request** object.
- Created **SparseFieldSets** object that helps in this kind of *filter*.

## 0.0.2
### Base Implementation of Kitsumon

- Created Kitsu object.
- Created API and Kitsumon exceptions.
- Created KitsuValueNormalizer helper.
- Created Authentication Method Class. (The only available one, more in the future?)
- Created KitsuClient.
- Created first KitsuObject, Authentication.
- Created base implementation of Kitsumon.
- Added build and clean Scripts.
- Updated the README.md after talking with Kitsu developers.

## 0.0.1

- Initial version. Created the Package's repo structure.