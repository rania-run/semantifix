// ─────────────────────────────────────────────────────────────────────────────
// interactive/tappable_list.dart
//
// Demonstrates the MissingSemanticsWrapper violation on:
//   - GestureDetector   (custom tap handling)
//   - InkWell           (Material tap with ripple effect)
//
// Violations in this file: 2× MissingSemanticsWrapper
//
// HOW TO RUN:
//   sfix scan --path example/interactive/
//   sfix fix  --path example/interactive/ --dry-run --skip-ai
//   sfix fix  --path example/interactive/ --skip-ai
//
// NOTE: MissingSemanticsWrapper is rated "warning" (not "error") because
// the fix requires wrapping the widget, which needs a human or AI to choose
// the right label. In --skip-ai mode, SemantiFix flags it but won't auto-fix.
// Use AI mode (`sfix fix --path ...`) for automatic wrapping.
// ─────────────────────────────────────────────────────────────────────────────

// Flutter stubs — lets this file be valid Dart without the Flutter SDK.
class Widget {
  const Widget();
}

class BuildContext {}

class StatelessWidget extends Widget {
  const StatelessWidget() : super();
  Widget build(BuildContext context) => const Widget();
}

class Column extends Widget {
  const Column({List<Widget>? children}) : super();
}

class Text extends Widget {
  const Text(String data) : super();
}

class Semantics extends Widget {
  const Semantics({Widget? child, String? label}) : super();
}

class GestureDetector extends Widget {
  const GestureDetector({void Function()? onTap, Widget? child}) : super();
}

class InkWell extends Widget {
  const InkWell({void Function()? onTap, Widget? child}) : super();
}

// ─────────────────────────────────────────────────────────────────────────────

/// A list of tappable cards that are missing Semantics wrappers.
///
/// `GestureDetector` and `InkWell` handle touch input but don't communicate
/// their purpose to screen readers. Wrapping them in a `Semantics` widget
/// gives screen readers the label they need to announce the tap target.
///
/// Without a Semantics wrapper, a screen reader user hears nothing or
/// just "double tap to activate" with no context about what will happen.
class TappableList extends StatelessWidget {
  const TappableList() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. GestureDetector — opens a detail page ─────────────────────────
        //
        // ✗ VIOLATION: not wrapped in Semantics
        //
        // What SemantiFix adds (AI mode) — wraps in Semantics:
        //   Semantics(
        //     label: 'Open article details',
        //     child: GestureDetector(...),
        //   )
        GestureDetector(
          onTap: () {},
          child: const Text('Read full article'),
        ),

        // ── 2. InkWell — navigates to a user profile ─────────────────────────
        //
        // ✗ VIOLATION: not wrapped in Semantics
        //
        // What SemantiFix adds (AI mode) — wraps in Semantics:
        //   Semantics(
        //     label: 'View user profile',
        //     child: InkWell(...),
        //   )
        InkWell(
          onTap: () {},
          child: const Text('View profile'),
        ),

        // ── OK examples — already accessible ─────────────────────────────────
        //
        // ✓ No violations — both are wrapped in Semantics.
        //   SemantiFix will leave these unchanged.
        const Semantics(
          label: 'Navigate to settings',
          child: GestureDetector(
            child: Text('Open settings'),
          ),
        ),

        const Semantics(
          label: 'Submit the form',
          child: InkWell(
            child: Text('Submit'),
          ),
        ),
      ],
    );
  }
}
