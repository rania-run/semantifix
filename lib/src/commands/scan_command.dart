import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../auditor/auditor.dart';
import '../shared/logger.dart';

/// CLI command that scans a path for accessibility violations and prints JSON results.
class ScanCommand extends Command<void> {
  ScanCommand() {
    argParser.addOption('path',
        abbr: 'p', help: 'Path to scan', defaultsTo: '.');
    argParser.addFlag('json',
        help:
            'Output violations as JSON (default behaviour; flag for script discoverability)',
        defaultsTo: false);
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Verbose output', defaultsTo: false);
  }

  @override
  String get name => 'scan';

  @override
  String get description =>
      'Scan Dart/Flutter files for accessibility violations and print JSON.';

  @override
  Future<void> run() async {
    final path = argResults!['path'] as String;
    final verbose = argResults!['verbose'] as bool;
    final logger = Logger(verbose: verbose);
    final auditor = Auditor(logger: logger);

    final results = await auditor.auditPath(path);
    final output = results
        .map((r) => {
              'file': r.filePath,
              'violations': r.violations.map((v) => v.toJson()).toList(),
            })
        .toList();

    stdout.writeln(const JsonEncoder.withIndent('  ').convert(output));
  }
}
