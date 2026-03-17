import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart' as p;

import '../shared/errors.dart';
import '../shared/logger.dart';
import 'ast_visitor.dart';
import 'file_discovery.dart';
import 'types.dart';

/// Scans Dart source files for accessibility violations using the Dart analyzer.
class Auditor {
  /// Creates an [Auditor], optionally supplying a [Logger].
  Auditor({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  /// Discovers all `.dart` files under [path] and returns one [AuditResult]
  /// per file, each containing any violations found.
  Future<List<AuditResult>> auditPath(String path) async {
    final absolutePath = p.absolute(path);
    final files = discoverDartFiles(absolutePath);

    if (files.isEmpty) {
      _logger.warn('No Dart files found at: $absolutePath');
      return [];
    }

    _logger.info('Scanning ${files.length} file(s)…');

    final collection = AnalysisContextCollection(includedPaths: files);
    final results = <AuditResult>[];

    for (final filePath in files) {
      try {
        final context = collection.contextFor(filePath);
        final result = await context.currentSession.getResolvedUnit(filePath);

        if (result is! ResolvedUnitResult) {
          _logger.warn('Could not resolve: $filePath');
          continue;
        }

        final visitor = SemantifixAstVisitor(
          filePath: filePath,
          lineInfo: result.lineInfo,
          source: result.content,
        );
        result.unit.visitChildren(visitor);

        results.add(
            AuditResult(filePath: filePath, violations: visitor.violations));
      } on Exception catch (e) {
        throw AuditorException('Failed to analyse $filePath', cause: e);
      }
    }

    return results;
  }
}
