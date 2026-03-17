import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:semantifix/src/writer/backup_manager.dart';

void main() {
  group('BackupManager', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('backup_manager_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('creates backup file that mirrors original content', () {
      final original = File(p.join(tempDir.path, 'widget.dart'));
      original.writeAsStringSync('class Foo {}');

      final backupsDir = p.join(tempDir.path, 'backups');
      final manager = BackupManager(backupsDir: backupsDir);
      final entry = manager.backup(original.path);

      expect(File(entry.backupPath).existsSync(), isTrue);
      expect(File(entry.backupPath).readAsStringSync(), equals('class Foo {}'));
    });

    test('backup path is inside backupsDir', () {
      final original = File(p.join(tempDir.path, 'widget.dart'));
      original.writeAsStringSync('content');

      final backupsDir = p.join(tempDir.path, 'backups');
      final manager = BackupManager(backupsDir: backupsDir);
      final entry = manager.backup(original.path);

      expect(entry.backupPath, startsWith(backupsDir));
    });

    test('all backups in same session share the same session directory', () {
      final f1 = File(p.join(tempDir.path, 'a.dart'))..writeAsStringSync('a');
      final f2 = File(p.join(tempDir.path, 'b.dart'))..writeAsStringSync('b');

      final backupsDir = p.join(tempDir.path, 'backups');
      final manager = BackupManager(backupsDir: backupsDir);
      final e1 = manager.backup(f1.path);
      final e2 = manager.backup(f2.path);

      expect(p.dirname(e1.backupPath), equals(p.dirname(e2.backupPath)));
    });
  });
}
