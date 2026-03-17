# Changelog

## 0.1.1

### Bug Fixes
- fix: combine release and publish into single workflow to bypass GITHUB_TOKEN restriction (#5)

### Other Changes
- chore: add automated release preparation workflow (#7)


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