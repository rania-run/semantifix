# Changelog

## 0.1.0

- Initial release.
- `sfix scan` — detect accessibility violations in Flutter source files.
- `sfix fix` — auto-fix violations with AI-generated labels or placeholder stubs.
- Detects `MissingSemanticLabel` on `Image`, `Image.asset`, `Image.network`.
- Detects `MissingTooltip` on `IconButton`, `FloatingActionButton`.
- Detects `MissingSemanticsWrapper` on `GestureDetector`, `InkWell`.
- `--skip-ai` mode for offline use without an API key.
- `--dry-run` mode to preview fixes without modifying files.
- Atomic writes with automatic backups to `.semantifix_backups/`.
- JSON reports written to `.semantifix_reports/`.