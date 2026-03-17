import 'types.dart';

/// Builds the Claude prompt for a given [AiFixRequest].
///
/// The prompt instructs the model to return only a JSON object with a
/// `suggestedFix` key containing the corrected widget expression.
String buildPrompt(AiFixRequest request) {
  final v = request.violation;
  return '''You are an accessibility expert fixing Flutter/Dart source code.

Violation type: ${v.violationType}
Widget: ${v.widget}
File: ${v.file} (line ${v.line}, column ${v.column})

Source snippet to fix:
```dart
${request.contextSnippet}
```

Return ONLY valid JSON with no markdown fences, no explanation, no extra keys:
{"suggestedFix": "<the complete corrected widget expression>"}

Rules:
- Return the full corrected expression (not just the added argument).
- For missing semanticLabel: add a descriptive semanticLabel named argument.
- For missing tooltip: add a short, descriptive tooltip string.
- For missing Semantics wrapper: wrap the GestureDetector in a Semantics widget with an appropriate label.
- Do not change any logic or other arguments.''';
}
