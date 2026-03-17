// Full pipeline dry-run against test/fixtures/mock_widget.dart.
// Prints JSON report to stdout.
//
// Usage:
//   dart run tool/repro.dart --skip-ai
//   ANTHROPIC_API_KEY=xxx dart run tool/repro.dart
import 'dart:convert';
import 'dart:io';

import 'package:semantifix/src/ai_engine/ai_engine.dart';
import 'package:semantifix/src/ai_engine/types.dart';
import 'package:semantifix/src/auditor/auditor.dart';
import 'package:semantifix/src/config/config.dart';
import 'package:semantifix/src/models/fix.dart';
import 'package:semantifix/src/models/report.dart';
import 'package:semantifix/src/shared/logger.dart';
import 'package:semantifix/src/strategist/strategist.dart';
import 'package:semantifix/src/strategist/types.dart';
import 'package:semantifix/src/writer/backup_manager.dart';
import 'package:semantifix/src/writer/writer.dart';

Future<void> main(List<String> args) async {
  final skipAi = args.contains('--skip-ai');
  final config = SemantifixConfig(dryRun: true, skipAi: skipAi);
  final logger = Logger(verbose: true);

  logger.info('=== SemantiFix repro (dry-run) ===');
  logger.info('Mode: ${skipAi ? "without AI (--skip-ai)" : "with AI"}');

  // 1. Audit fixture
  final auditor = Auditor(logger: logger);
  final auditResults = await auditor.auditPath('test/fixtures');
  final allViolations = auditResults.expand((r) => r.violations).toList();
  final scannedFiles = auditResults.map((r) => r.filePath).toList();

  logger.info(
      'Found ${allViolations.length} violation(s) in ${scannedFiles.length} file(s)');

  // 2. Strategize
  final strategist = Strategist();
  final prioritized = strategist.classifyAll(allViolations, skipAi: skipAi);

  // 3. AI fixes (if enabled)
  final allFixes = <Fix>[];
  if (!skipAi) {
    final aiRequests = prioritized
        .where((p) => p.strategy == FixStrategy.ai)
        .map((p) => AiFixRequest(
              violation: p.violation,
              contextSnippet: p.violation.sourceSnippet,
            ))
        .toList();

    if (aiRequests.isNotEmpty) {
      final engine = AiEngine(logger: logger);
      final aiFixes = await engine.generateFixes(aiRequests);
      allFixes.addAll(aiFixes);
    }
  }

  // Auto / manual fixes
  for (final pv in prioritized) {
    if (pv.strategy == FixStrategy.auto) {
      allFixes.add(AutoFix(
        violation: pv.violation,
        replacement: '/* TODO: ${pv.violation.violationType} */',
        description: 'Auto placeholder for ${pv.violation.violationType}',
      ));
    } else if (pv.strategy == FixStrategy.manual) {
      allFixes.add(ManualFix(
        violation: pv.violation,
        guidance: 'Wrap ${pv.violation.widget} in a Semantics widget.',
      ));
    }
  }

  // 4. Writer (dry-run)
  final writer = Writer(
    backupManager: BackupManager(backupsDir: config.backupsDir),
    logger: logger,
  );
  final writeResults = writer.applyAll(allFixes, dryRun: true);
  final filesModified =
      writeResults.where((r) => r.success).map((r) => r.filePath).toList();

  // 5. Report
  final report = Report(
    timestamp: DateTime.now().toUtc(),
    scannedFiles: scannedFiles,
    violations: allViolations,
    fixes: allFixes,
    filesModified: filesModified,
    dryRun: true,
  );

  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report.toJson()));
}
