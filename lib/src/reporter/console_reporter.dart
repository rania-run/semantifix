import 'dart:io';

import '../models/report.dart';

/// Prints an ANSI-coloured summary of a [Report] to stdout.
class ConsoleReporter {
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';

  /// Prints a formatted summary of [report] to stdout.
  void print(Report report) {
    final dryTag = report.dryRun ? ' $_yellow[dry-run]$_reset' : '';
    stdout.writeln('');
    stdout.writeln('$_bold$_cyan━━━ SemantiFix report$dryTag $_reset');
    stdout.writeln('  Scanned files : ${report.scannedFiles.length}');
    stdout.writeln('  Violations    : $_red${report.totalViolations}$_reset');
    stdout.writeln('  Fixed         : $_green${report.fixedCount}$_reset');
    stdout.writeln('  Manual needed : $_yellow${report.manualCount}$_reset');
    stdout.writeln('  Files modified: ${report.filesModified.length}');
    stdout.writeln('$_bold$_cyan━━━$_reset');
  }
}
