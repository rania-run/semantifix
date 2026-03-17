// ─────────────────────────────────────────────────────────────────────────────
// buttons/action_buttons.dart
//
// Demonstrates the MissingTooltip violation on:
//   - IconButton            (tap to perform an action)
//   - FloatingActionButton  (primary screen action)
//
// Violations in this file: 2× MissingTooltip
//
// HOW TO RUN:
//   sfix scan --path example/buttons/
//   sfix fix  --path example/buttons/ --dry-run --skip-ai
//   sfix fix  --path example/buttons/ --skip-ai
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

class Icon extends Widget {
  const Icon(Object icon) : super();
}

abstract class Icons {
  static const Object add = 'add';
  static const Object delete = 'delete';
  static const Object share = 'share';
  static const Object edit = 'edit';
}

class IconButton extends Widget {
  const IconButton({
    required void Function() onPressed,
    required Widget icon,
    String? tooltip,
  }) : super();
}

class FloatingActionButton extends Widget {
  const FloatingActionButton({
    required void Function() onPressed,
    Widget? child,
    String? tooltip,
  }) : super();
}

// ─────────────────────────────────────────────────────────────────────────────

/// An action bar showing buttons with missing `tooltip` properties.
///
/// The `tooltip` serves two purposes:
///   1. It's read aloud by screen readers when the button is focused.
///   2. It appears as a pop-up label on long-press (helpful for everyone).
///
/// Without `tooltip`, users with visual impairments hear only "button"
/// and have no idea what the button does.
class ActionBar extends StatelessWidget {
  const ActionBar() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. IconButton — delete action ─────────────────────────────────────
        //
        // ✗ VIOLATION: missing tooltip
        //
        // What SemantiFix adds (AI mode):
        //   tooltip: 'Delete this item'
        //
        // What SemantiFix adds (--skip-ai):
        //   tooltip: 'TODO: describe action'
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
        ),

        // ── 2. FloatingActionButton — compose action ──────────────────────────
        //
        // ✗ VIOLATION: missing tooltip
        //
        // What SemantiFix adds (AI mode):
        //   tooltip: 'Compose new message'
        //
        // What SemantiFix adds (--skip-ai):
        //   tooltip: 'TODO: describe action'
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),

        // ── OK examples — these are already accessible ────────────────────────
        //
        // ✓ No violations — tooltip is present on both.
        //   SemantiFix will leave these unchanged.
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share),
          tooltip: 'Share with others',
        ),

        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.edit),
          tooltip: 'Edit profile',
        ),
      ],
    );
  }
}
