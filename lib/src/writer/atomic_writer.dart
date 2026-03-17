import 'dart:io';

import '../shared/errors.dart';

class AtomicWriter {
  /// Writes [content] to [path] atomically via a temp file + rename.
  void write(String path, String content) {
    final tmpPath = '$path.sfix_tmp';
    final tmp = File(tmpPath);

    try {
      tmp.writeAsStringSync(content);
      // Verify the write round-trips correctly
      final verified = tmp.readAsStringSync();
      if (verified != content) {
        tmp.deleteSync();
        throw WriterException('Atomic write verification failed for $path');
      }
      tmp.renameSync(path);
    } on WriterException {
      rethrow;
    } on Exception catch (e) {
      if (tmp.existsSync()) tmp.deleteSync();
      throw WriterException('Atomic write failed for $path', cause: e);
    }
  }
}
