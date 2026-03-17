import '../models/violation.dart';
import 'rules/ai_rules.dart';
import 'rules/auto_rules.dart';
import 'types.dart';

/// Assigns a [FixStrategy] to each [Violation] based on the current mode.
class Strategist {
  /// Returns a [PrioritizedViolation] for [violation].
  ///
  /// When [skipAi] is `true`, falls back to [autoStrategy]; otherwise uses
  /// [aiStrategy].
  PrioritizedViolation classify(Violation violation, {bool skipAi = false}) {
    final strategy = skipAi ? autoStrategy(violation) : aiStrategy(violation);
    return PrioritizedViolation(violation: violation, strategy: strategy);
  }

  /// Classifies all [violations] in one pass.
  List<PrioritizedViolation> classifyAll(
    List<Violation> violations, {
    bool skipAi = false,
  }) =>
      violations.map((v) => classify(v, skipAi: skipAi)).toList();
}
