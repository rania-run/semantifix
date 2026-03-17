import 'dart:io';

/// ANSI-coloured logger that writes to stderr.
///
/// All output goes to `stderr` to keep `stdout` clean for machine-readable
/// output (JSON reports, scan results).
class Logger {
  /// Creates a [Logger]. Set [verbose] to `true` to enable [debug] output.
  Logger({this.verbose = false});

  /// Whether debug-level messages are emitted.
  final bool verbose;

  static const _reset = '\x1B[0m';
  static const _cyan = '\x1B[36m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _gray = '\x1B[90m';

  /// Logs an informational [msg] in cyan.
  void info(String msg) => stderr.writeln('$_cyan[info]$_reset $msg');

  /// Logs a warning [msg] in yellow.
  void warn(String msg) => stderr.writeln('$_yellow[warn]$_reset $msg');

  /// Logs an error [msg] in red.
  void error(String msg) => stderr.writeln('$_red[error]$_reset $msg');

  /// Logs a debug [msg] in gray; emitted only when [verbose] is `true`.
  void debug(String msg) {
    if (verbose) stderr.writeln('$_gray[debug]$_reset $msg');
  }
}
