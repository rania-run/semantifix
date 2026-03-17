import 'package:args/command_runner.dart';

import 'package:semantifix/src/commands/fix_command.dart';
import 'package:semantifix/src/commands/scan_command.dart';

/// Entry point for the `sfix` CLI.
Future<void> main(List<String> args) async {
  final runner = CommandRunner<void>(
    'sfix',
    'SemantiFix — detect and fix Flutter/Dart accessibility violations.',
  )
    ..addCommand(ScanCommand())
    ..addCommand(FixCommand());

  await runner.run(args);
}
