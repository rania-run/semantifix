import 'package:test/test.dart';

import 'package:semantifix/src/ai_engine/response_parser.dart';
import 'package:semantifix/src/shared/errors.dart';

void main() {
  group('parseResponse', () {
    test('parses clean JSON', () {
      final result = parseResponse(
          '{"suggestedFix": "Image.network(url, semanticLabel: \'photo\')"}');
      expect(result.suggestedFix, contains('semanticLabel'));
    });

    test('parses JSON wrapped in ```json fence', () {
      const raw =
          '```json\n{"suggestedFix": "Image.network(url, semanticLabel: \'photo\')"}\n```';
      final result = parseResponse(raw);
      expect(result.suggestedFix, contains('semanticLabel'));
    });

    test('parses JSON wrapped in plain ``` fence', () {
      const raw =
          '```\n{"suggestedFix": "Image.network(url, semanticLabel: \'photo\')"}\n```';
      final result = parseResponse(raw);
      expect(result.suggestedFix, isNotEmpty);
    });

    test('throws AiEngineException for missing suggestedFix key', () {
      expect(
        () => parseResponse('{"other": "value"}'),
        throwsA(isA<AiEngineException>()),
      );
    });

    test('throws AiEngineException for invalid JSON', () {
      expect(
        () => parseResponse('not json at all'),
        throwsA(isA<AiEngineException>()),
      );
    });
  });
}
