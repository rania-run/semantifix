import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../ai_engine/ai_engine.dart';
import '../ai_engine/dry_run_client.dart';
import '../ai_engine/types.dart';
import '../auditor/auditor.dart';
import '../config/config.dart';
import '../models/fix.dart';
import '../models/report.dart';
import '../models/violation.dart';
import '../reporter/reporter.dart';
import '../shared/logger.dart';
import '../strategist/strategist.dart';
import '../strategist/types.dart';
import '../writer/backup_manager.dart';
import '../writer/writer.dart';

/// CLI command that audits a path for accessibility violations and applies fixes.
class FixCommand extends Command<void> {
  FixCommand() {
    argParser.addOption('path',
        abbr: 'p', help: 'Path to fix', defaultsTo: '.');
    argParser.addFlag('dry-run',
        help: 'Preview changes without writing files', defaultsTo: false);
    argParser.addFlag('skip-ai',
        help: 'Run auto-fixes only (no API key required)', defaultsTo: false);
    argParser.addFlag('dry-run-ai',
        help:
            'Log AI prompts to stderr, return placeholder fixes (no API key needed)',
        defaultsTo: false);
    argParser.addFlag('json',
        help: 'Output report as JSON to stdout instead of console formatting',
        defaultsTo: false);
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Verbose output', defaultsTo: false);
  }

  @override
  String get name => 'fix';

  @override
  String get description =>
      'Detect and fix accessibility violations in Dart/Flutter files.';

  @override
  Future<void> run() async {
    final path = argResults!['path'] as String;
    final dryRun = argResults!['dry-run'] as bool;
    final skipAi = argResults!['skip-ai'] as bool;
    final dryRunAi = argResults!['dry-run-ai'] as bool;
    final jsonOutput = argResults!['json'] as bool;
    final verbose = argResults!['verbose'] as bool;

    final config = SemantifixConfig(dryRun: dryRun, skipAi: skipAi);
    final logger = Logger(verbose: verbose);

    // 1. Audit
    final auditor = Auditor(logger: logger);
    final auditResults = await auditor.auditPath(path);
    final allViolations = auditResults.expand((r) => r.violations).toList();
    final scannedFiles = auditResults.map((r) => r.filePath).toList();

    // 2. Strategize
    final strategist = Strategist();
    final prioritized = strategist.classifyAll(allViolations, skipAi: skipAi);

    // 3. AI fixes
    final allFixes = <Fix>[];
    final aiRequests = prioritized
        .where((p) => p.strategy == FixStrategy.ai)
        .map((p) => AiFixRequest(
              violation: p.violation,
              contextSnippet: p.violation.sourceSnippet,
            ))
        .toList();

    if (aiRequests.isNotEmpty && !skipAi) {
      final engine = dryRunAi
          ? AiEngine(client: DryRunAiClient(), logger: logger)
          : AiEngine(logger: logger);
      final aiFixes = await engine.generateFixes(aiRequests);
      allFixes.addAll(aiFixes);
    }

    // Auto fixes for skip-ai mode
    for (final pv in prioritized) {
      if (pv.strategy == FixStrategy.auto) {
        allFixes.add(_makeAutoFix(pv));
      } else if (pv.strategy == FixStrategy.manual) {
        allFixes.add(ManualFix(
          violation: pv.violation,
          guidance:
              'Manually wrap ${pv.violation.widget} in a Semantics widget.',
        ));
      }
    }

    // 4. Write
    final writer = Writer(
      backupManager: BackupManager(backupsDir: config.backupsDir),
      logger: logger,
    );
    final writeResults = writer.applyAll(allFixes, dryRun: dryRun);
    final filesModified =
        writeResults.where((r) => r.success).map((r) => r.filePath).toList();

    // 5. Report
    final report = Report(
      timestamp: DateTime.now().toUtc(),
      scannedFiles: scannedFiles,
      violations: allViolations,
      fixes: allFixes,
      filesModified: filesModified,
      dryRun: dryRun,
    );

    if (jsonOutput) {
      stdout
          .writeln(const JsonEncoder.withIndent('  ').convert(report.toJson()));
    } else {
      final reporter = Reporter(reportsDir: config.reportsDir, logger: logger);
      reporter.report(report);
    }
  }

  Fix _makeAutoFix(PrioritizedViolation pv) {
    final v = pv.violation;
    // Inject a stub named arg before the closing paren of the constructor args.
    final replacement = switch (v) {
      MissingSemanticLabel() => v.sourceSnippet.replaceFirst(
          RegExp(r'\)(\s*)$'),
          ", semanticLabel: 'TODO: describe image')",
        ),
      MissingTooltip() => v.sourceSnippet.replaceFirst(
          RegExp(r'\)(\s*)$'),
          ", tooltip: 'TODO: describe action')",
        ),
      MissingSemanticsWrapper() => v.sourceSnippet,
    };
    return AutoFix(
      violation: v,
      replacement: replacement,
      description: 'Auto-inserted placeholder for ${v.violationType}',
    );
  }
}
