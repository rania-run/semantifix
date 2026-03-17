/// Base exception for all SemantiFix errors.
class SemantifixException implements Exception {
  const SemantifixException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => cause != null
      ? 'SemantifixException: $message\nCaused by: $cause'
      : 'SemantifixException: $message';
}

/// Thrown when file discovery or reading fails.
class AuditorException extends SemantifixException {
  const AuditorException(super.message, {super.cause});

  @override
  String toString() => cause != null
      ? 'AuditorException: $message\nCaused by: $cause'
      : 'AuditorException: $message';
}

/// Thrown when AI engine encounters an error (missing key, HTTP failure, bad JSON).
class AiEngineException extends SemantifixException {
  const AiEngineException(super.message, {super.cause});

  @override
  String toString() => cause != null
      ? 'AiEngineException: $message\nCaused by: $cause'
      : 'AiEngineException: $message';
}

/// Thrown when file writing or backup fails.
class WriterException extends SemantifixException {
  const WriterException(super.message, {super.cause});

  @override
  String toString() => cause != null
      ? 'WriterException: $message\nCaused by: $cause'
      : 'WriterException: $message';
}

/// Thrown when configuration is invalid.
class ConfigException extends SemantifixException {
  const ConfigException(super.message, {super.cause});

  @override
  String toString() => cause != null
      ? 'ConfigException: $message\nCaused by: $cause'
      : 'ConfigException: $message';
}
