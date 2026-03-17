/// The outcome of attempting to write a single file.
class WriteResult {
  const WriteResult(
      {required this.filePath, required this.success, this.error});

  /// Absolute path to the file that was (or would have been) written.
  final String filePath;

  /// Whether the write succeeded (or would succeed in dry-run mode).
  final bool success;

  /// Error message if [success] is `false`.
  final String? error;
}

/// A record linking an original file to its backup copy.
class BackupEntry {
  const BackupEntry({required this.originalPath, required this.backupPath});

  /// Absolute path to the original source file.
  final String originalPath;

  /// Absolute path to the backup copy.
  final String backupPath;
}
