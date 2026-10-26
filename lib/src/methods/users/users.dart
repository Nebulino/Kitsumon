//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'package:kitsumon/kitsu.dart';
import 'package:kitsumon/kitsumon_exceptions.dart';
import 'package:kitsumon/src/core/kitsu.dart';
import 'package:kitsumon/src/core/request.dart';
import 'package:kitsumon/src/helpers/filter.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:kitsumon/src/helpers/pagination.dart';
import 'package:kitsumon/src/helpers/sorting.dart';
import 'package:kitsumon/src/helpers/sparse_fieldsets.dart';
import 'package:kitsumon/src/methods/core/base_method.dart';

/// Methods to query and retrieve users from the Kitsu API.
class UsersMethods implements BaseMethod {
  @override
  final String methodRadix = 'users';

  @override
  final Kitsu api;

  /// Creates [UsersMethods] bound to [api].
  UsersMethods(this.api);

  /// Fetches a collection of users with optional filters, pagination, sorting,
  /// includes, and sparse fieldsets.
  ///
  /// Parameters that are `null` or empty are not sent.
  Future<UserResults> fetchCollection({
    String? name,
    String? slug,
    List<int>? ids,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (name != null && name.isNotEmpty) {
      filters.add(Filter('name', name));
    }
    if (slug != null && slug.isNotEmpty) {
      filters.add(Filter('slug', slug));
    }
    if (ids != null && ids.isNotEmpty) {
      filters.add(Filter('id', ids.join(',')));
    }
    if (customFilters != null && customFilters.isNotEmpty) {
      filters.addAll(customFilters);
    }

    final request = Request(
      this,
      filters: filters.isNotEmpty ? filters : null,
      pagination: pagination,
      sorting: sorting,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.get();
    return UserResults.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a single user resource by [id].
  Future<UserResult> fetchResource(
    int id, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final request = Request(
      this,
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.fetch(id);
    return UserResult.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a user by [slug], or returns `null` when no user matches.
  Future<User?> fetchBySlug(
    String slug, {
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final results = await fetchCollection(
      slug: slug,
      pagination: Pagination(limit: 1),
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    return results.data?.firstOrNull;
  }

  /// Fetches the currently authenticated user via `filter[self]=true`.
  ///
  /// Throws a [KitsumonException] without sending any network request when
  /// [Kitsu.authenticated] is `false`.
  Future<UserResult> fetchCurrentUser({
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    if (!api.authenticated) {
      throw KitsumonException(
        description: 'Authentication required to fetch the current user.',
      );
    }

    final results = await fetchCollection(
      customFilters: [Filter('self', 'true')],
      includes: includes,
      sparseFieldSets: sparseFieldSets,
    );

    return UserResult(
      data: results.data?.firstOrNull,
      included: results.included,
    )
      ..meta = results.meta
      ..links = results.links;
  }
}
