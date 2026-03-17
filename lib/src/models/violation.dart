/// Sealed class hierarchy representing accessibility violations detected in Dart/Flutter source.
sealed class Violation {
  const Violation({
    required this.file,
    required this.line,
    required this.column,
    required this.widget,
    required this.sourceOffset,
    required this.sourceLength,
    required this.sourceSnippet,
  });

  final String file;
  final int line;
  final int column;
  final String widget;
  final int sourceOffset;
  final int sourceLength;
  final String sourceSnippet;

  String get violationType;
  String get severity;
  String get fixable;

  Map<String, dynamic> toJson() => {
        'file': file,
        'line': line,
        'column': column,
        'widget': widget,
        'violation': violationType,
        'severity': severity,
        'fixable': fixable,
        'sourceOffset': sourceOffset,
        'sourceLength': sourceLength,
        'sourceSnippet': sourceSnippet,
      };
}

/// Image/Image.asset/Image.network missing semanticLabel.
final class MissingSemanticLabel extends Violation {
  const MissingSemanticLabel({
    required super.file,
    required super.line,
    required super.column,
    required super.widget,
    required super.sourceOffset,
    required super.sourceLength,
    required super.sourceSnippet,
  });

  @override
  String get violationType => 'missing_semantic_label';
  @override
  String get severity => 'error';
  @override
  String get fixable => 'ai';
}

/// IconButton missing tooltip.
final class MissingTooltip extends Violation {
  const MissingTooltip({
    required super.file,
    required super.line,
    required super.column,
    required super.widget,
    required super.sourceOffset,
    required super.sourceLength,
    required super.sourceSnippet,
  });

  @override
  String get violationType => 'missing_tooltip';
  @override
  String get severity => 'error';
  @override
  String get fixable => 'ai';
}

/// GestureDetector missing Semantics wrapper.
final class MissingSemanticsWrapper extends Violation {
  const MissingSemanticsWrapper({
    required super.file,
    required super.line,
    required super.column,
    required super.widget,
    required super.sourceOffset,
    required super.sourceLength,
    required super.sourceSnippet,
  });

  @override
  String get violationType => 'missing_semantics_wrapper';
  @override
  String get severity => 'warning';
  @override
  String get fixable => 'ai';
}
