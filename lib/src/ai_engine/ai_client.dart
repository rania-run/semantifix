/// Abstract interface for all AI back-ends used by [AiEngine].
abstract interface class AiClient {
  /// Sends [prompt] to the AI model and returns the raw text response.
  Future<String> sendMessage(String prompt);
}
