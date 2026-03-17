import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:semantifix/src/auditor/ast_visitor.dart';
import 'package:semantifix/src/models/violation.dart';

void main() {
  group('SemantifixAstVisitor', () {
    late List<Violation> violations;

    setUpAll(() async {
      final fixturePath = p.absolute('test/fixtures/mock_widget.dart');
      final collection =
          AnalysisContextCollection(includedPaths: [fixturePath]);
      final context = collection.contextFor(fixturePath);
      final result = await context.currentSession.getResolvedUnit(fixturePath);

      expect(result, isA<ResolvedUnitResult>(),
          reason: 'Could not resolve fixture');
      final resolved = result as ResolvedUnitResult;

      final visitor = SemantifixAstVisitor(
        filePath: fixturePath,
        lineInfo: resolved.lineInfo,
        source: resolved.content,
      );
      resolved.unit.visitChildren(visitor);
      violations = visitor.violations;
    });

    test('detects exactly 5 violations', () {
      expect(violations, hasLength(5));
    });

    test('detects MissingSemanticLabel on Image.network', () {
      expect(
        violations.whereType<MissingSemanticLabel>(),
        hasLength(1),
      );
      expect(violations.whereType<MissingSemanticLabel>().first.widget,
          'Image.network');
    });

    test('detects MissingTooltip on IconButton', () {
      final tooltips = violations.whereType<MissingTooltip>().toList();
      expect(tooltips, hasLength(2));
      expect(tooltips.map((v) => v.widget),
          containsAll(['IconButton', 'FloatingActionButton']));
    });

    test('detects MissingTooltip on FloatingActionButton', () {
      expect(
        violations.whereType<MissingTooltip>().map((v) => v.widget),
        contains('FloatingActionButton'),
      );
    });

    test('detects MissingSemanticsWrapper on GestureDetector', () {
      final wrappers = violations.whereType<MissingSemanticsWrapper>().toList();
      expect(wrappers, hasLength(2));
      expect(wrappers.map((v) => v.widget),
          containsAll(['GestureDetector', 'InkWell']));
    });

    test('detects MissingSemanticsWrapper on InkWell', () {
      expect(
        violations.whereType<MissingSemanticsWrapper>().map((v) => v.widget),
        contains('InkWell'),
      );
    });

    test('all violations have valid line numbers', () {
      for (final v in violations) {
        expect(v.line, greaterThan(0));
        expect(v.column, greaterThan(0));
      }
    });
  });
}
