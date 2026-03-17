import '../../models/violation.dart';
import '../types.dart';

/// All violation types are routed to AI when AI is enabled.
FixStrategy aiStrategy(Violation v) => FixStrategy.ai;
