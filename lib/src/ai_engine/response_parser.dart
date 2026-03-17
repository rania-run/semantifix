import 'dart:convert';

import '../shared/errors.dart';
import 'types.dart';

/// Parses [raw] AI response text into an [AiFixResponse].
///
/// Strips optional markdown fences before decoding JSON.
/// Throws [AiEngineException] if the JSON is invalid or missing `suggestedFix`.
AiFixResponse parseResponse(String raw) {
  final cleaned = raw
      .replaceFirst(RegExp(r'^```(?:json)?\s*', multiLine: true), '')
      .replaceFirst(RegExp(r'\s*```$', multiLine: true), '')
      .trim();

  try {
    final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
    final fix = decoded['suggestedFix'];
    if (fix == null || fix is! String) {
      throw const AiEngineException(
          'Response JSON missing "suggestedFix" string field');
    }
    return AiFixResponse(suggestedFix: fix);
  } on AiEngineException {
    rethrow;
  } on Exception catch (e) {
    throw AiEngineException('Failed to parse AI response JSON', cause: e);
  }
}
