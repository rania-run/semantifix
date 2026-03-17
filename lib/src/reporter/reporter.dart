import '../models/report.dart';
import '../shared/logger.dart';
import 'console_reporter.dart';
import 'json_reporter.dart';

/// Coordinates console and JSON reporting for a completed fix run.
class Reporter {
  /// Creates a [Reporter] that writes JSON reports to [reportsDir].
  Reporter({required this.reportsDir, Logger? logger})
      : _json = JsonReporter(reportsDir: reportsDir),
        _console = ConsoleReporter(),
        _logger = logger ?? Logger();

  final JsonReporter _json;
  final ConsoleReporter _console;
  final Logger _logger;
  final String reportsDir;

  /// Prints [report] to the console and, unless it is a dry run, writes a
  /// JSON file to [reportsDir].
  void report(Report report) {
    _console.print(report);
    if (!report.dryRun) {
      final path = _json.write(report);
      _logger.info('Report written to $path');
    }
  }
}
