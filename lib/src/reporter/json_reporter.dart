import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../models/report.dart';
import '../shared/utils.dart';

/// Persists a [Report] as an indented JSON file in [reportsDir].
class JsonReporter {
  /// Creates a [JsonReporter] that writes to [reportsDir].
  JsonReporter({required this.reportsDir});

  /// Directory where report JSON files are written.
  final String reportsDir;

  /// Writes [report] to a timestamped JSON file and returns its path.
  String write(Report report) {
    final dir = Directory(reportsDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final fileName = '${timestamp().replaceAll(':', '-')}.json';
    final filePath = p.join(reportsDir, fileName);
    File(filePath).writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(report.toJson()),
    );
    return filePath;
  }
}
