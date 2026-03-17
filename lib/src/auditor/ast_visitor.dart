import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../models/violation.dart';

/// AST visitor that detects accessibility violations in a single Dart file.
///
/// Detects [MissingSemanticLabel], [MissingTooltip], and
/// [MissingSemanticsWrapper] by walking the resolved AST.
class SemantifixAstVisitor extends RecursiveAstVisitor<void> {
  /// Creates a visitor for [filePath] using the given [lineInfo] and raw [source].
  SemantifixAstVisitor(
      {required this.filePath, required this.lineInfo, required this.source});

  final String filePath;
  final LineInfo lineInfo;
  final String source;
  final List<Violation> violations = [];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final typeName = node.constructorName.type.name.lexeme;
    final namedConstructor = node.constructorName.name?.name;

    final isImage = typeName == 'Image' &&
        (namedConstructor == null ||
            namedConstructor == 'asset' ||
            namedConstructor == 'network');

    final isIconButton = typeName == 'IconButton' && namedConstructor == null;
    final isGestureDetector =
        typeName == 'GestureDetector' && namedConstructor == null;
    final isFab =
        typeName == 'FloatingActionButton' && namedConstructor == null;
    final isInkWell = typeName == 'InkWell' && namedConstructor == null;

    if (isImage) {
      _checkMissingNamedArg(node, 'semanticLabel', typeName, namedConstructor);
    } else if (isIconButton) {
      _checkMissingNamedArg(node, 'tooltip', typeName, null);
    } else if (isFab) {
      _checkMissingNamedArg(node, 'tooltip', 'FloatingActionButton', null);
    } else if (isGestureDetector) {
      _checkMissingSemanticsWrapper(node, 'GestureDetector');
    } else if (isInkWell) {
      _checkMissingSemanticsWrapper(node, 'InkWell');
    }

    super.visitInstanceCreationExpression(node);
  }

  void _checkMissingNamedArg(
    InstanceCreationExpression node,
    String argName,
    String typeName,
    String? namedConstructor,
  ) {
    final args = node.argumentList.arguments;
    final hasArg = args
        .whereType<NamedExpression>()
        .any((e) => e.name.label.name == argName);
    if (hasArg) return;

    final widgetLabel =
        namedConstructor != null ? '$typeName.$namedConstructor' : typeName;
    violations.add(_makeViolation(node, typeName, widgetLabel, argName));
  }

  void _checkMissingSemanticsWrapper(
      InstanceCreationExpression node, String widgetName) {
    // Walk ancestors — if any is a Semantics instance creation, skip.
    AstNode? current = node.parent;
    while (current != null) {
      if (current is InstanceCreationExpression) {
        final name = current.constructorName.type.name.lexeme;
        if (name == 'Semantics') return;
      }
      current = current.parent;
    }
    violations.add(_makeViolationWrapper(node, widgetName));
  }

  Violation _makeViolation(
    InstanceCreationExpression node,
    String typeName,
    String widgetLabel,
    String missingArg,
  ) {
    final location = lineInfo.getLocation(node.offset);
    final snippet = _extractSnippet(node.offset, node.length);
    return switch (missingArg) {
      'semanticLabel' => MissingSemanticLabel(
          file: filePath,
          line: location.lineNumber,
          column: location.columnNumber,
          widget: widgetLabel,
          sourceOffset: node.offset,
          sourceLength: node.length,
          sourceSnippet: snippet,
        ),
      'tooltip' => MissingTooltip(
          file: filePath,
          line: location.lineNumber,
          column: location.columnNumber,
          widget: widgetLabel,
          sourceOffset: node.offset,
          sourceLength: node.length,
          sourceSnippet: snippet,
        ),
      _ => MissingSemanticLabel(
          file: filePath,
          line: location.lineNumber,
          column: location.columnNumber,
          widget: widgetLabel,
          sourceOffset: node.offset,
          sourceLength: node.length,
          sourceSnippet: snippet,
        ),
    };
  }

  Violation _makeViolationWrapper(
      InstanceCreationExpression node, String widgetName) {
    final location = lineInfo.getLocation(node.offset);
    final snippet = _extractSnippet(node.offset, node.length);
    return MissingSemanticsWrapper(
      file: filePath,
      line: location.lineNumber,
      column: location.columnNumber,
      widget: widgetName,
      sourceOffset: node.offset,
      sourceLength: node.length,
      sourceSnippet: snippet,
    );
  }

  String _extractSnippet(int offset, int length) {
    final end = (offset + length).clamp(0, source.length);
    final raw = source.substring(offset.clamp(0, source.length), end);
    // Truncate to first 120 chars for readability
    return raw.length > 120 ? '${raw.substring(0, 120)}…' : raw;
  }
}
