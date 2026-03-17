import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:semantifix/src/writer/atomic_writer.dart';

void main() {
  group('AtomicWriter', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('atomic_writer_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('writes content to target file', () {
      final path = p.join(tempDir.path, 'test.dart');
      const content = 'void main() {}';
      AtomicWriter().write(path, content);
      expect(File(path).readAsStringSync(), equals(content));
    });

    test('leaves no temp file after success', () {
      final path = p.join(tempDir.path, 'test.dart');
      AtomicWriter().write(path, 'content');
      expect(File('$path.sfix_tmp').existsSync(), isFalse);
    });

    test('overwrites existing file', () {
      final path = p.join(tempDir.path, 'test.dart');
      File(path).writeAsStringSync('old content');
      AtomicWriter().write(path, 'new content');
      expect(File(path).readAsStringSync(), equals('new content'));
    });
  });
}
