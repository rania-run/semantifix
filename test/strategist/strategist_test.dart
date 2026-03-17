import 'package:test/test.dart';

import 'package:semantifix/src/models/violation.dart';
import 'package:semantifix/src/strategist/strategist.dart';
import 'package:semantifix/src/strategist/types.dart';

const _base = (
  file: 'test.dart',
  line: 1,
  column: 1,
  sourceOffset: 0,
  sourceLength: 10,
  sourceSnippet: 'snippet',
);

Violation makeSemanticLabel() => MissingSemanticLabel(
      file: _base.file,
      line: _base.line,
      column: _base.column,
      widget: 'Image',
      sourceOffset: _base.sourceOffset,
      sourceLength: _base.sourceLength,
      sourceSnippet: _base.sourceSnippet,
    );

Violation makeTooltip() => MissingTooltip(
      file: _base.file,
      line: _base.line,
      column: _base.column,
      widget: 'IconButton',
      sourceOffset: _base.sourceOffset,
      sourceLength: _base.sourceLength,
      sourceSnippet: _base.sourceSnippet,
    );

Violation makeWrapper() => MissingSemanticsWrapper(
      file: _base.file,
      line: _base.line,
      column: _base.column,
      widget: 'GestureDetector',
      sourceOffset: _base.sourceOffset,
      sourceLength: _base.sourceLength,
      sourceSnippet: _base.sourceSnippet,
    );

void main() {
  group('Strategist', () {
    final strategist = Strategist();

    group('with AI enabled', () {
      test('MissingSemanticLabel → ai', () {
        expect(
            strategist.classify(makeSemanticLabel()).strategy, FixStrategy.ai);
      });

      test('MissingTooltip → ai', () {
        expect(strategist.classify(makeTooltip()).strategy, FixStrategy.ai);
      });

      test('MissingSemanticsWrapper → ai', () {
        expect(strategist.classify(makeWrapper()).strategy, FixStrategy.ai);
      });
    });

    group('with --skip-ai', () {
      test('MissingSemanticLabel → auto', () {
        expect(strategist.classify(makeSemanticLabel(), skipAi: true).strategy,
            FixStrategy.auto);
      });

      test('MissingTooltip → auto', () {
        expect(strategist.classify(makeTooltip(), skipAi: true).strategy,
            FixStrategy.auto);
      });

      test('MissingSemanticsWrapper → manual (no safe auto-wrap)', () {
        expect(strategist.classify(makeWrapper(), skipAi: true).strategy,
            FixStrategy.manual);
      });
    });
  });
}
