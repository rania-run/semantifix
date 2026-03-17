import 'package:test/test.dart';

import 'package:semantifix/src/ai_engine/prompt_builder.dart';
import 'package:semantifix/src/ai_engine/types.dart';
import 'package:semantifix/src/models/violation.dart';

void main() {
  group('buildPrompt', () {
    const violation = MissingSemanticLabel(
      file: 'lib/widgets/avatar.dart',
      line: 12,
      column: 5,
      widget: 'Image.network',
      sourceOffset: 100,
      sourceLength: 25,
      sourceSnippet: 'Image.network(url)',
    );

    const request = AiFixRequest(
        violation: violation, contextSnippet: 'Image.network(url)');
    final prompt = buildPrompt(request);

    test('contains violation type', () {
      expect(prompt, contains('missing_semantic_label'));
    });

    test('contains widget name', () {
      expect(prompt, contains('Image.network'));
    });

    test('contains file path and line', () {
      expect(prompt, contains('lib/widgets/avatar.dart'));
      expect(prompt, contains('line 12'));
    });

    test('contains source snippet', () {
      expect(prompt, contains('Image.network(url)'));
    });

    test('instructs JSON-only response', () {
      expect(prompt, contains('"suggestedFix"'));
      expect(prompt, contains('no markdown'));
    });
  });
}
