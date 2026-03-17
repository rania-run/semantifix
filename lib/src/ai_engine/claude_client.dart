import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../shared/errors.dart';
import 'ai_client.dart';

/// Production [AiClient] that calls the Anthropic Messages API.
///
/// Requires `ANTHROPIC_API_KEY` in the environment.
class ClaudeClient implements AiClient {
  /// Creates a [ClaudeClient].
  ///
  /// [client] defaults to a fresh [http.Client]; [model] defaults to
  /// `claude-sonnet-4-6`; [maxTokens] defaults to 1024.
  ClaudeClient({http.Client? client, String? model, int maxTokens = 1024})
      : _client = client ?? http.Client(),
        _model = model ?? 'claude-sonnet-4-6',
        _maxTokens = maxTokens;

  final http.Client _client;
  final String _model;
  final int _maxTokens;

  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  @override
  Future<String> sendMessage(String prompt) async {
    final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiEngineException(
        'ANTHROPIC_API_KEY environment variable is not set. '
        'Use --skip-ai to run without AI.',
      );
    }

    final body = jsonEncode({
      'model': _model,
      'max_tokens': _maxTokens,
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
    });

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw AiEngineException(
        'Claude API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final content = decoded['content'] as List<dynamic>?;
    if (content == null || content.isEmpty) {
      throw const AiEngineException('Empty content in Claude API response');
    }
    return (content.first as Map<String, dynamic>)['text'] as String;
  }
}
