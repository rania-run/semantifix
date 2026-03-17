import 'dart:io';

import '../models/fix.dart';
import '../shared/logger.dart';
import 'atomic_writer.dart';
import 'backup_manager.dart';
import 'dart_patcher.dart';
import 'types.dart';

/// Applies a list of [Fix]es to the filesystem, backing up files first.
class Writer {
  /// Creates a [Writer] with the given [backupManager].
  Writer({
    required this.backupManager,
    Logger? logger,
  })  : _atomic = AtomicWriter(),
        _logger = logger ?? Logger();

  final BackupManager backupManager;
  final AtomicWriter _atomic;
  final Logger _logger;

  /// Groups fixes by file, backs up each file, patches, and writes atomically.
  /// Returns one [WriteResult] per modified file.
  List<WriteResult> applyAll(List<Fix> fixes, {bool dryRun = false}) {
    // Group by file path
    final byFile = <String, List<Fix>>{};
    for (final fix in fixes) {
      (byFile[fix.violation.file] ??= []).add(fix);
    }

    final results = <WriteResult>[];
    for (final entry in byFile.entries) {
      final filePath = entry.key;
      final fileFixes = entry.value;

      if (dryRun) {
        _logger.info(
            '[dry-run] Would patch ${fileFixes.length} fix(es) in $filePath');
        results.add(WriteResult(filePath: filePath, success: true));
        continue;
      }

      try {
        backupManager.backup(filePath);
        final source = File(filePath).readAsStringSync();
        final patched = applyFixes(source, fileFixes);
        _atomic.write(filePath, patched);
        _logger.info('Patched $filePath (${fileFixes.length} fix(es))');
        results.add(WriteResult(filePath: filePath, success: true));
      } on Exception catch (e) {
        _logger.error('Failed to patch $filePath: $e');
        results.add(WriteResult(
            filePath: filePath, success: false, error: e.toString()));
      }
    }
    return results;
  }
}
