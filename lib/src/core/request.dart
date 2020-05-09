//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

import 'dart:convert';

import 'package:kitsumon/src/helpers/filter.dart';
import 'package:kitsumon/src/helpers/includes.dart';
import 'package:kitsumon/src/helpers/pagination.dart';
import 'package:kitsumon/src/helpers/sorting.dart';
import 'package:kitsumon/src/helpers/sparse_fieldsets.dart';
import 'package:kitsumon/src/methods/core/base_method.dart';

/// It contains all the capabilities of a Request to [KitsuAPI]
///
/// [KitsuAPI]: https://kitsu.docs.apiary.io/#introduction/json-api
class Request {
  /// The [BaseMethod] object that helps connecting to the API.
  final BaseMethod caller;

  /// It contains all the filter applied to the request.
  final List<Filter> filters;

  /// It contains the information about a possible pagination.
  final Pagination pagination;

  /// It contains the information about a possible sorting.
  final Sorting sorting;

  /// It contains the related resources to include into the response.
  final Includes includes;

  /// It helps returning a specific set of fields in the response of the
  /// request.
  final SparseFieldSets sparseFieldSets;

  Request(
    this.caller, {
    this.filters,
    this.pagination,
    this.sorting,
    this.includes,
    this.sparseFieldSets,
  });

  /// It executes a GET request using the Request Parameters.
  Future<dynamic> get() async {
    var parameters = <String, dynamic>{};

    // Adds each filter in the request...
    filters.forEach((Filter filter) {
      parameters.addAll(filter?.format() ?? {});
    });

    // Adds the pagination in the request...
    parameters
      ..addAll(pagination?.format() ?? {})

      // Adds the sorting in the request...
      ..addAll(sorting?.format() ?? {})

      // Adds the includes in the request...
      ..addAll(includes?.build() ?? {})

      // Adds the needed field in the request...
      ..addAll(sparseFieldSets?.build() ?? {});

    return jsonDecode(await caller.api.client.get(
      method: caller.methodRadix,
      parameters: parameters,
    ));
  }

  /// It executes a GET request using the Request Parameters
  /// to fetch a resource.
  Future<dynamic> fetch(int resourceID) async {
    var parameters = <String, dynamic>{};

    // Adds the includes in the request...
    parameters
      ..addAll(includes?.build() ?? {})

      // Adds the needed field in the request...
      ..addAll(sparseFieldSets?.build() ?? {});

    return jsonDecode(await caller.api.client.get(
      method: caller.methodRadix + '/${resourceID}',
      parameters: parameters,
    ));
  }
}
