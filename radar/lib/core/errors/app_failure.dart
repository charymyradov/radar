/// Classified failures surfaced to the UI.
enum FailureKind {
  permissionDenied,
  cameraUnavailable,
  modelUnavailable,
  storageFull,
  database,
  fileAccess,
  calibrationMissing,
  unknown,
}

/// A user facing error. Never contains a stack trace; the UI shows [message]
/// or a localized default based on [kind].
class AppFailure implements Exception {
  const AppFailure(this.kind, {this.message, this.cause});

  final FailureKind kind;
  final String? message;
  final Object? cause;

  /// Heuristic detection of "disk full" errors coming from SQLite or dart:io.
  static bool looksLikeStorageFull(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('sqlite_full') ||
        text.contains('database or disk is full') ||
        text.contains('disk is full') ||
        text.contains('no space left') ||
        text.contains('enospc') ||
        text.contains('cannot allocate');
  }

  static AppFailure from(Object error) {
    if (error is AppFailure) return error;
    if (looksLikeStorageFull(error)) {
      return AppFailure(FailureKind.storageFull, cause: error);
    }
    return AppFailure(FailureKind.unknown, cause: error);
  }

  @override
  String toString() => 'AppFailure(${kind.name}'
      '${message == null ? '' : ': $message'})';
}
