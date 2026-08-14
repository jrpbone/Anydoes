enum AppFailureCode {
  validation,
  persistence,
  notification,
  permission,
  fileAccess,
  checksum,
  schemaVersion,
  referenceIntegrity,
}

final class AppFailure implements Exception {
  const AppFailure({
    required this.code,
    required this.message,
    required this.recovery,
    this.cause,
  });

  final AppFailureCode code;
  final String message;
  final String recovery;
  final Object? cause;

  @override
  String toString() => 'AppFailure(${code.name}): $message';
}
