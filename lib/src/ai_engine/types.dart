import '../models/violation.dart';

/// A request to the AI engine to generate a fix for a single [violation].
class AiFixRequest {
  const AiFixRequest({required this.violation, required this.contextSnippet});

  /// The violation to fix.
  final Violation violation;

  /// Source snippet surrounding the violation, passed to the AI for context.
  final String contextSnippet;
}

/// The parsed response from the AI engine for a single fix request.
class AiFixResponse {
  const AiFixResponse({required this.suggestedFix});

  /// The corrected widget expression suggested by the AI.
  final String suggestedFix;
}
