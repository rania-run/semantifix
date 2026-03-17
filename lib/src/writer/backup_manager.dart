import 'dart:io';

import 'package:path/path.dart' as p;

import '../shared/errors.dart';
import '../shared/utils.dart';
import 'types.dart';

/// Creates per-session backups of Dart files before they are patched.
class BackupManager {
  /// Creates a [BackupManager] that stores backups under [backupsDir].
  BackupManager({required this.backupsDir});

  /// Root directory for all backups.
  final String backupsDir;
  String? _sessionDir;

  /// Session-scoped subdirectory; created lazily on first use.
  String get sessionDir {
    _sessionDir ??= p.join(backupsDir, timestamp().replaceAll(':', '-'));
    return _sessionDir!;
  }

  /// Backs up [filePath] to [sessionDir] and returns a [BackupEntry].
  ///
  /// Throws [WriterException] if the copy fails.
  BackupEntry backup(String filePath) {
    final dir = Directory(sessionDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);

    // Flatten the absolute path into a safe filename to avoid directory traversal
    final abs = p.absolute(filePath);
    final flat = abs
        .replaceFirst(RegExp(r'^[/\\]+'), '')
        .replaceAll(RegExp(r'[/\\]'), '_');
    final backupPath = p.join(sessionDir, flat);

    try {
      File(filePath).copySync(backupPath);
    } on Exception catch (e) {
      throw WriterException('Backup failed for $filePath', cause: e);
    }

    return BackupEntry(originalPath: filePath, backupPath: backupPath);
  }
}
