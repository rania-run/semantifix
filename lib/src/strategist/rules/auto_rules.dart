import '../../models/violation.dart';
import '../types.dart';

/// Returns [FixStrategy.auto] for violations that have deterministic fixes,
/// [FixStrategy.manual] for anything else when AI is skipped.
FixStrategy autoStrategy(Violation v) {
  return switch (v) {
    MissingSemanticLabel() => FixStrategy.auto,
    MissingTooltip() => FixStrategy.auto,
    MissingSemanticsWrapper() => FixStrategy.manual, // no safe auto-wrap
  };
}
