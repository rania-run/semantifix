import 'defaults.dart';

/// Runtime configuration for a SemantiFix scan/fix run.
class SemantifixConfig {
  /// Creates an [SemantifixConfig] with sensible defaults.
  const SemantifixConfig({
    this.model = defaultModel,
    this.maxTokens = defaultMaxTokens,
    this.reportsDir = defaultReportsDir,
    this.backupsDir = defaultBackupsDir,
    this.skipAi = false,
    this.dryRun = false,
  });

  /// The Claude model identifier to use for AI fixes.
  final String model;

  /// Maximum tokens for each AI response.
  final int maxTokens;

  /// Directory where JSON reports are written.
  final String reportsDir;

  /// Directory where file backups are stored before patching.
  final String backupsDir;

  /// When `true`, skips AI and uses deterministic auto-fixes only.
  final bool skipAi;

  /// When `true`, no files are modified; changes are previewed only.
  final bool dryRun;

  /// Deserialises a config from [json], falling back to defaults for missing keys.
  factory SemantifixConfig.fromJson(Map<String, dynamic> json) {
    return SemantifixConfig(
      model: (json['model'] as String?) ?? defaultModel,
      maxTokens: (json['maxTokens'] as int?) ?? defaultMaxTokens,
      reportsDir: (json['reportsDir'] as String?) ?? defaultReportsDir,
      backupsDir: (json['backupsDir'] as String?) ?? defaultBackupsDir,
      skipAi: (json['skipAi'] as bool?) ?? false,
      dryRun: (json['dryRun'] as bool?) ?? false,
    );
  }

  /// Returns a copy of this config with the given fields overridden.
  SemantifixConfig copyWith({
    String? model,
    int? maxTokens,
    String? reportsDir,
    String? backupsDir,
    bool? skipAi,
    bool? dryRun,
  }) {
    return SemantifixConfig(
      model: model ?? this.model,
      maxTokens: maxTokens ?? this.maxTokens,
      reportsDir: reportsDir ?? this.reportsDir,
      backupsDir: backupsDir ?? this.backupsDir,
      skipAi: skipAi ?? this.skipAi,
      dryRun: dryRun ?? this.dryRun,
    );
  }
}
