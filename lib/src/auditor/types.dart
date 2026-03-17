import '../models/violation.dart';

/// The result of auditing a single Dart file.
class AuditResult {
  const AuditResult({required this.filePath, required this.violations});

  /// Absolute path to the scanned file.
  final String filePath;

  /// All accessibility violations found in [filePath].
  final List<Violation> violations;
}
