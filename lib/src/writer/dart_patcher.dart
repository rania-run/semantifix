import '../models/fix.dart';

/// Applies a list of [Fix]es to [source], returning the patched string.
/// Fixes are applied descending by offset to prevent drift.
String applyFixes(String source, List<Fix> fixes) {
  // Filter to only fixes that have a replacement (AutoFix / AiFix)
  final applicable = fixes.where((f) => f is AutoFix || f is AiFix).toList()
    ..sort(
        (a, b) => b.violation.sourceOffset.compareTo(a.violation.sourceOffset));

  var result = source;
  for (final fix in applicable) {
    final offset = fix.violation.sourceOffset;
    final length = fix.violation.sourceLength;
    final replacement = switch (fix) {
      final AutoFix f => f.replacement,
      final AiFix f => f.replacement,
      ManualFix() => null,
    };
    if (replacement == null) continue;
    result = result.substring(0, offset) +
        replacement +
        result.substring(offset + length);
  }
  return result;
}
