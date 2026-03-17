import 'violation.dart';
import 'fix.dart';

/// Top-level aggregate report for a scan/fix run.
class Report {
  const Report({
    required this.timestamp,
    required this.scannedFiles,
    required this.violations,
    required this.fixes,
    required this.filesModified,
    required this.dryRun,
  });

  final DateTime timestamp;
  final List<String> scannedFiles;
  final List<Violation> violations;
  final List<Fix> fixes;
  final List<String> filesModified;
  final bool dryRun;

  /// Total number of violations found.
  int get totalViolations => violations.length;

  /// Number of violations that were (or would be) fixed automatically.
  int get fixedCount =>
      fixes.whereType<AutoFix>().length + fixes.whereType<AiFix>().length;

  /// Number of violations requiring manual developer intervention.
  int get manualCount => fixes.whereType<ManualFix>().length;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'dryRun': dryRun,
        'summary': {
          'scannedFiles': scannedFiles.length,
          'totalViolations': totalViolations,
          'fixed': fixedCount,
          'manual': manualCount,
          'filesModified': filesModified.length,
        },
        'violations': violations.map((v) => v.toJson()).toList(),
        'fixes': fixes.map((f) => f.toJson()).toList(),
        'filesModified': filesModified,
      };
}
