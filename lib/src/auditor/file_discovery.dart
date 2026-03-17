import 'dart:io';
import 'package:path/path.dart' as p;

/// Recursively finds all `.dart` files under [rootPath], excluding hidden
/// directories and `build/`.
List<String> discoverDartFiles(String rootPath) {
  final root = Directory(rootPath);
  if (!root.existsSync()) return [];

  return root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) {
        final parts = p.split(f.path);
        return !parts.any((part) => part.startsWith('.') || part == 'build');
      })
      .map((f) => f.path)
      .toList();
}
