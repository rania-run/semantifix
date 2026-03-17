import 'dart:io';

import 'ai_client.dart';

/// Implements [AiClient] for --dry-run-ai mode.
/// Logs the full prompt to stderr and returns a placeholder JSON response.
class DryRunAiClient implements AiClient {
  @override
  Future<String> sendMessage(String prompt) async {
    stderr.writeln('\n[DRY RUN AI] Prompt:\n$prompt\n');
    return '{"suggestedFix": "/* DRY RUN — see prompt logged above */"}';
  }
}
