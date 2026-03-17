# SemantiFix

**Detect and fix accessibility violations in Flutter/Dart source files — with or without AI.**

SemantiFix is a command-line tool that statically analyses your Flutter codebase for common accessibility (a11y) issues
and automatically applies fixes. It uses the Dart analyzer to resolve your code and either generates contextual fixes
via the Claude AI API or inserts placeholder stubs you can fill in manually.

---

## What it detects

| Violation                   | Widget(s)                               | Severity |
|-----------------------------|-----------------------------------------|----------|
| Missing `semanticLabel`     | `Image`, `Image.asset`, `Image.network` | error    |
| Missing `tooltip`           | `IconButton`, `FloatingActionButton`    | error    |
| Missing `Semantics` wrapper | `GestureDetector`, `InkWell`            | warning  |

---

## Installation

**From pub.dev:**

```bash
dart pub global activate semantifix
```

**From source:**

```bash
git clone https://github.com/rania-run/semantifix.git
cd semantifix
dart pub get
dart pub global activate --source path .
```

---

## Usage

### Scan — find violations without changing anything

```bash
sfix scan --path lib/
```

Outputs a JSON array of all violations found, grouped by file. Pipe it, script it, or feed it to CI.

```bash
# Scan a specific file
sfix scan --path lib/screens/home.dart

# Verbose output
sfix scan --path lib/ --verbose
```

### Fix — detect and apply fixes

```bash
# Preview what would change (no files written)
sfix fix --path lib/ --dry-run

# Apply AI-generated fixes (requires ANTHROPIC_API_KEY)
export ANTHROPIC_API_KEY=your_key_here
sfix fix --path lib/

# Apply placeholder stubs only — no API key needed
sfix fix --path lib/ --skip-ai

# Output a JSON report instead of the console summary
sfix fix --path lib/ --json
```

---

## Two modes

| Mode           | How to run           | What it fixes                                                                                                              | API key      |
|----------------|----------------------|----------------------------------------------------------------------------------------------------------------------------|--------------|
| **With AI**    | `sfix fix`           | All violations — Claude generates contextual, meaningful labels and tooltips                                               | Required     |
| **Without AI** | `sfix fix --skip-ai` | `MissingSemanticLabel` and `MissingTooltip` get `TODO` stubs injected; `MissingSemanticsWrapper` flagged for manual review | Not required |

**With AI** example output:

```
// Before
Image.network(url)

// After (Claude infers from context)
Image.network(url, semanticLabel: 'Profile photo of the current user')
```

**Without AI** example output:

```
// After (--skip-ai stub)
Image.network(url, semanticLabel: 'TODO: describe image')
```

---

## How it works

```
1. Discover   — find all .dart files under the given path
2. Resolve    — run the Dart analyzer to build a fully-resolved AST
3. Audit      — SemantifixAstVisitor walks the AST, flags violations
4. Strategize — classify each violation: ai | auto | manual
5. Fix        — AI or auto-generate the replacement source
6. Write      — apply patches atomically (temp file + rename), back up originals first
7. Report     — write a JSON report to .semantifix_reports/ and print a console summary
```

Backups of every modified file are saved to `.semantifix_backups/` before any change is written, so you can always
recover the originals.

---

## CLI flags

### `sfix fix`

| Flag               | Default | Description                                        |
|--------------------|---------|----------------------------------------------------|
| `--path` / `-p`    | `.`     | Path to scan and fix                               |
| `--dry-run`        | false   | Preview changes without writing any files          |
| `--skip-ai`        | false   | Auto-fixes only — no API key required              |
| `--dry-run-ai`     | false   | Log AI prompts to stderr, return placeholder fixes |
| `--json`           | false   | Print the full report as JSON to stdout            |
| `--verbose` / `-v` | false   | Verbose logging                                    |

### `sfix scan`

| Flag               | Default | Description     |
|--------------------|---------|-----------------|
| `--path` / `-p`    | `.`     | Path to scan    |
| `--verbose` / `-v` | false   | Verbose logging |

---

## Requirements

- Dart SDK `>=3.4.0`
- For AI fixes: an [Anthropic API key](https://console.anthropic.com/)

---

## License

MIT — see [LICENSE](LICENSE).
