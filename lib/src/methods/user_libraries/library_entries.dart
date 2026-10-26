//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

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

/// Methods to query, create, update, and delete library entries on the Kitsu
/// API.
class LibraryEntriesMethods implements BaseMethod {
  @override
  final String methodRadix = 'library-entries';

  @override
  final Kitsu api;

  /// Creates [LibraryEntriesMethods] bound to [api].
  LibraryEntriesMethods(this.api);

  /// Fetches a collection of library entries with optional filters, pagination,
  /// sorting, includes, and sparse fieldsets.
  ///
  /// When [includeMedia] is `true`, `include=media` is added to the request.
  /// Parameters that are `null` or empty are not sent.
  Future<LibraryEntryResults> fetchCollection({
    int? userId,
    String? mediaType,
    String? kind,
    List<LibraryEntryStatus>? statuses,
    bool? includeMedia,
    List<Filter>? customFilters,
    Pagination? pagination,
    Sorting? sorting,
    Includes? includes,
    SparseFieldSets? sparseFieldSets,
  }) async {
    final filters = <Filter>[];

    if (userId != null) {
      filters.add(Filter('userId', userId));
    }
    if (mediaType != null && mediaType.isNotEmpty) {
      filters.add(Filter('mediaType', mediaType));
    }
    if (kind != null && kind.isNotEmpty) {
      filters.add(Filter('kind', kind));
    }
    if (statuses != null && statuses.isNotEmpty) {
      filters.add(Filter('status', statuses.map((s) => s.status).join(',')));
    }
    if (customFilters != null && customFilters.isNotEmpty) {
      filters.addAll(customFilters);
    }

    final Includes? effectiveIncludes;
    if (includeMedia == true) {
      final existing = includes?.relationships ?? const <String>[];
      effectiveIncludes = Includes([
        ...existing,
        if (!existing.contains('media')) 'media',
      ]);
    } else {
      effectiveIncludes = includes;
    }

    final request = Request(
      this,
      filters: filters.isNotEmpty ? filters : null,
      pagination: pagination,
      sorting: sorting,
      includes: effectiveIncludes,
      sparseFieldSets: sparseFieldSets,
    );

    final dynamic response = await request.get();
    return LibraryEntryResults.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a single library entry resource by [id].
  Future<LibraryEntryResult> fetchResource(
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
    return LibraryEntryResult.fromJson(response as Map<String, dynamic>);
  }

  /// Creates a library entry linking [userId] to [mediaId] of [mediaType].
  ///
  /// Only the optional attributes that are non-null are included in the posted
  /// JSON:API document. Throws a [KitsumonException] without sending any
  /// request when [Kitsu.authenticated] is `false`.
  Future<LibraryEntryResult> createResource({
    required int userId,
    required int mediaId,
    required String mediaType,
    LibraryEntryStatus? status,
    int? progress,
    int? ratingTwenty,
    String? notes,
    bool? private,
    bool? reconsuming,
    int? reconsumeCount,
  }) async {
    _requireAuthentication('create a library entry');

    final attributes = _buildAttributes(
      status: status,
      progress: progress,
      ratingTwenty: ratingTwenty,
      notes: notes,
      private: private,
      reconsuming: reconsuming,
      reconsumeCount: reconsumeCount,
    );

    final body = <String, dynamic>{
      'data': <String, dynamic>{
        'type': 'libraryEntries',
        'attributes': attributes,
        'relationships': <String, dynamic>{
          'user': <String, dynamic>{
            'data': <String, dynamic>{
              'type': 'users',
              'id': userId.toString(),
            },
          },
          'media': <String, dynamic>{
            'data': <String, dynamic>{
              'type': mediaType,
              'id': mediaId.toString(),
            },
          },
        },
      },
    };

    final dynamic response = await api.client.post(
      method: methodRadix,
      body: body,
    );
    final dynamic decoded =
        (response is String) ? jsonDecode(response) : response;
    return LibraryEntryResult.fromJson(decoded as Map<String, dynamic>);
  }

  /// Partially updates library entry [id] with the provided attributes.
  ///
  /// Only the attributes that are non-null are sent in the `PATCH` payload.
  /// Throws a [KitsumonException] without sending any request when
  /// [Kitsu.authenticated] is `false`.
  Future<LibraryEntryResult> updateResource(
    int id, {
    LibraryEntryStatus? status,
    int? progress,
    int? ratingTwenty,
    String? notes,
    bool? private,
    bool? reconsuming,
    int? reconsumeCount,
  }) async {
    _requireAuthentication('update a library entry');

    final attributes = _buildAttributes(
      status: status,
      progress: progress,
      ratingTwenty: ratingTwenty,
      notes: notes,
      private: private,
      reconsuming: reconsuming,
      reconsumeCount: reconsumeCount,
    );

    final body = <String, dynamic>{
      'data': <String, dynamic>{
        'type': 'libraryEntries',
        'id': id.toString(),
        'attributes': attributes,
      },
    };

    final dynamic response = await api.client.patch(
      method: '$methodRadix/$id',
      body: body,
    );
    final dynamic decoded =
        (response is String) ? jsonDecode(response) : response;
    return LibraryEntryResult.fromJson(decoded as Map<String, dynamic>);
  }

  /// Deletes library entry [id], returning `true` when the server responds with
  /// a 2xx or 204 status.
  ///
  /// Throws a [KitsumonException] without sending any request when
  /// [Kitsu.authenticated] is `false`.
  Future<bool> deleteResource(int id) async {
    _requireAuthentication('delete a library entry');
    await api.client.delete(method: '$methodRadix/$id');
    return true;
  }

  void _requireAuthentication(String action) {
    if (!api.authenticated) {
      throw KitsumonException(
        description: 'Authentication required to $action.',
      );
    }
  }

  Map<String, dynamic> _buildAttributes({
    LibraryEntryStatus? status,
    int? progress,
    int? ratingTwenty,
    String? notes,
    bool? private,
    bool? reconsuming,
    int? reconsumeCount,
  }) =>
      <String, dynamic>{
        if (status != null) 'status': status.status,
        if (progress != null) 'progress': progress,
        if (ratingTwenty != null) 'ratingTwenty': ratingTwenty,
        if (notes != null) 'notes': notes,
        if (private != null) 'private': private,
        if (reconsuming != null) 'reconsuming': reconsuming,
        if (reconsumeCount != null) 'reconsumeCount': reconsumeCount,
      };
}
