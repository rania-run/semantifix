# SemantiFix — Examples

These examples show common Flutter accessibility violations and how **SemantiFix** detects and fixes them automatically.

---

## What is SemantiFix?

SemantiFix scans your Flutter source files, finds widgets that are missing accessibility information, and fixes them — either using AI (Claude) to generate meaningful labels, or by inserting placeholder stubs you can fill in later.

---

## Quickstart

**Step 1 — Install SemantiFix:**
```bash
dart pub global activate semantifix
```

**Step 2 — Pick an example folder and scan it:**
```bash
sfix scan --path example/basics/
```

**Step 3 — Fix the violations:**
```bash
# Option A: Let AI write meaningful labels (requires an API key)
export ANTHROPIC_API_KEY=your_key_here
sfix fix --path example/basics/

# Option B: Insert placeholder stubs (no API key needed)
sfix fix --path example/basics/ --skip-ai
```

That's it. SemantiFix backs up your original files to `.semantifix_backups/` before making any changes.

---

## The Three Violations SemantiFix Catches

| Violation | Affected Widgets | What's Missing | Severity |
|-----------|-----------------|----------------|----------|
| `MissingSemanticLabel` | `Image`, `Image.asset`, `Image.network` | `semanticLabel` parameter | error |
| `MissingTooltip` | `IconButton`, `FloatingActionButton` | `tooltip` parameter | error |
| `MissingSemanticsWrapper` | `GestureDetector`, `InkWell` | `Semantics` parent widget | warning |

### Why do these matter?

Screen readers (like TalkBack on Android and VoiceOver on iOS) rely on these properties to describe your UI to users who cannot see the screen. Without them, your app is effectively invisible to millions of people.

---

## Run Modes

| Mode | Command | What it fixes | API key? |
|------|---------|--------------|----------|
| **AI mode** | `sfix fix --path lib/` | Everything — Claude writes contextual labels | Yes |
| **Stub mode** | `sfix fix --path lib/ --skip-ai` | Images + buttons get `TODO:` placeholders; gestures need manual attention | No |
| **Dry run** | `sfix fix --path lib/ --dry-run` | Shows what *would* change, touches no files | No |

**Dry run is a safe way to preview changes before applying them.**

---

## Examples in This Folder

| Folder | What it demonstrates | Violations inside |
|--------|---------------------|-------------------|
| [`basics/`](basics/) | The simplest possible case — one image, one button | `MissingSemanticLabel`, `MissingTooltip` |
| [`images/`](images/) | Images loaded from assets and the network | `MissingSemanticLabel` (3 variants) |
| [`buttons/`](buttons/) | Icon buttons and floating action buttons | `MissingTooltip` (2 variants) |
| [`interactive/`](interactive/) | Tappable cards using `GestureDetector` and `InkWell` | `MissingSemanticsWrapper` |
| [`real_world/`](real_world/) | A realistic profile screen mixing all three violations | All three |

Start with `basics/` if you're new, or jump straight to `real_world/` to see everything at once.

---

## Before and After

### Image — missing `semanticLabel`

```dart
// BEFORE — screen readers have no idea what this image is
Image.network('https://example.com/avatar.png')

// AFTER (AI mode) — Claude generates a meaningful label
Image.network('https://example.com/avatar.png', semanticLabel: 'User profile photo')

// AFTER (stub mode) — you fill it in later
Image.network('https://example.com/avatar.png', semanticLabel: 'TODO: describe image')
```

### IconButton — missing `tooltip`

```dart
// BEFORE — tap target has no accessible name
IconButton(onPressed: () {}, icon: const Icon(Icons.delete))

// AFTER (AI mode)
IconButton(onPressed: () {}, icon: const Icon(Icons.delete), tooltip: 'Delete item')

// AFTER (stub mode)
IconButton(onPressed: () {}, icon: const Icon(Icons.delete), tooltip: 'TODO: describe action')
```

### GestureDetector — not wrapped in `Semantics`

```dart
// BEFORE — the tap action is invisible to screen readers
GestureDetector(
  onTap: () {},
  child: const Text('View details'),
)

// AFTER — screen readers can announce and activate it
Semantics(
  label: 'View details',
  child: GestureDetector(
    onTap: () {},
    child: const Text('View details'),
  ),
)
```

---

## Try it now

```bash
# Scan the real_world example — see all three violation types
sfix scan --path example/real_world/

# Preview fixes without touching files
sfix fix --path example/real_world/ --dry-run --skip-ai
```
