import '../models/fix.dart';
import '../shared/logger.dart';
import '../shared/utils.dart';
import 'ai_client.dart';
import 'claude_client.dart';
import 'prompt_builder.dart';
import 'response_parser.dart';
import 'types.dart';

/// Orchestrates AI-powered fix generation, batching requests to the [AiClient].
class AiEngine {
  /// Creates an [AiEngine].
  ///
  /// [client] defaults to [ClaudeClient]. [batchSize] controls how many
  /// requests are processed per batch (default 5).
  AiEngine({AiClient? client, Logger? logger, int batchSize = 5})
      : _client = client ?? ClaudeClient(),
        _logger = logger ?? Logger(),
        _batchSize = batchSize;

  final AiClient _client;
  final Logger _logger;
  final int _batchSize;

  /// Generates [AiFix]es for all [requests], processing them in batches.
  ///
  /// Failed individual requests are logged as warnings and skipped.
  Future<List<AiFix>> generateFixes(List<AiFixRequest> requests) async {
    final fixes = <AiFix>[];
    final batches = chunkList(requests, _batchSize);

    for (final batch in batches) {
      for (final request in batch) {
        try {
          _logger.debug(
              'AI fix for ${request.violation.widget} in ${request.violation.file}');
          final prompt = buildPrompt(request);
          final raw = await _client.sendMessage(prompt);
          final parsed = parseResponse(raw);
          fixes.add(AiFix(
            violation: request.violation,
            replacement: parsed.suggestedFix,
            suggestedFix: parsed.suggestedFix,
          ));
        } on Exception catch (e) {
          _logger.warn('AI fix failed for ${request.violation.widget}: $e');
        }
      }
    }

    return fixes;
  }
}
