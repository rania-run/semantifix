import '../models/violation.dart';

/// The fix strategy assigned to a violation.
enum FixStrategy {
  /// Can be fixed deterministically without AI (placeholder stub injection).
  auto,

  /// Requires AI to generate a contextual fix.
  ai,

  /// Requires developer intervention; no automated fix is safe.
  manual,
}

/// A [Violation] paired with its assigned [FixStrategy].
class PrioritizedViolation {
  const PrioritizedViolation({required this.violation, required this.strategy});

  /// The detected accessibility violation.
  final Violation violation;

  /// The strategy chosen for this violation.
  final FixStrategy strategy;
}
