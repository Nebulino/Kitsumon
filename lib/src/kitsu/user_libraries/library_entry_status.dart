//                                                         //
// Kitsumon - A fox-powered Kitsu.io API Wrapper for Dart. //
//              Copyright (c) 2020 Nebulino                //
//                                                         //

/// It contains the statuses a library entry can have on Kitsu.
///
/// Kitsu is free to add values: [parse] returns `null` for a status this enum
/// does not know, and [LibraryEntryAttributes.status] keeps the raw string the
/// API sent, so an unknown value is never lost and never throws.
enum LibraryEntryStatus {
  current,
  planned,
  completed,
  onHold,
  dropped;

  /// The value the API uses for this status.
  String get status => switch (this) {
        LibraryEntryStatus.current => 'current',
        LibraryEntryStatus.planned => 'planned',
        LibraryEntryStatus.completed => 'completed',
        LibraryEntryStatus.onHold => 'on_hold',
        LibraryEntryStatus.dropped => 'dropped',
      };

  /// The status matching [value], or `null` when the value is unknown or
  /// null.
  static LibraryEntryStatus? parse(String? value) {
    if (value == null) {
      return null;
    }
    for (final status in LibraryEntryStatus.values) {
      if (status.status == value) {
        return status;
      }
    }
    return null;
  }
}
