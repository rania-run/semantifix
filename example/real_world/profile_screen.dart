// ─────────────────────────────────────────────────────────────────────────────
// real_world/profile_screen.dart
//
// A realistic profile screen that mixes all three violation types.
// This is what a typical Flutter screen with accessibility issues looks like.
//
// Violations in this file:
//   3× MissingSemanticLabel   (profile photo, cover photo, badge icon)
//   2× MissingTooltip         (follow button, message button)
//   2× MissingSemanticsWrapper (post card tap, follower count tap)
//
// HOW TO RUN:
//   sfix scan --path example/real_world/
//   sfix fix  --path example/real_world/ --dry-run --skip-ai   ← safe preview
//   sfix fix  --path example/real_world/ --skip-ai             ← apply stubs
//
//   # For AI-generated labels (requires API key):
//   export ANTHROPIC_API_KEY=your_key_here
//   sfix fix --path example/real_world/
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

class Row extends Widget {
  const Row({List<Widget>? children}) : super();
}

class Text extends Widget {
  const Text(String data) : super();
}

class Icon extends Widget {
  const Icon(Object icon) : super();
}

abstract class Icons {
  static const Object message = 'message';
  static const Object personAdd = 'person_add';
  static const Object verified = 'verified';
}

class Image extends Widget {
  const Image({String? semanticLabel}) : super();
  const Image.asset(String path, {String? semanticLabel}) : super();
  const Image.network(String url, {String? semanticLabel}) : super();
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
// ProfileScreen — a typical user profile page with accessibility issues.
//
// Run SemantiFix on this file and all 7 violations will be fixed.
// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.username,
    required this.avatarUrl,
    required this.coverUrl,
  }) : super();

  final String username;
  final String avatarUrl;
  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Cover photo ───────────────────────────────────────────────────────
        //
        // ✗ VIOLATION 1: MissingSemanticLabel
        //   Screen readers cannot describe the cover photo.
        Image.network(coverUrl),

        // ── Profile photo ─────────────────────────────────────────────────────
        //
        // ✗ VIOLATION 2: MissingSemanticLabel
        //   Screen readers cannot describe the profile photo.
        Image.network(avatarUrl),

        Text(username),

        // ── Verified badge ────────────────────────────────────────────────────
        //
        // ✗ VIOLATION 3: MissingSemanticLabel
        //   The badge image has no description.
        const Image.asset('assets/icons/verified_badge.png'),

        // ── Action buttons ────────────────────────────────────────────────────
        Row(
          children: [
            // ✗ VIOLATION 4: MissingTooltip
            //   Screen reader announces "button" with no context.
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.personAdd),
            ),

            // ✗ VIOLATION 5: MissingTooltip
            //   Screen reader announces "button" with no context.
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.message),
            ),
          ],
        ),

        // ── Follower count (tappable to open follower list) ───────────────────
        //
        // ✗ VIOLATION 6: MissingSemanticsWrapper
        //   The tap opens a follower list, but screen readers don't know that.
        InkWell(
          onTap: () {},
          child: const Text('1,240 followers'),
        ),

        // ── Post card (tappable to open post detail) ──────────────────────────
        //
        // ✗ VIOLATION 7: MissingSemanticsWrapper
        //   The tap opens a post, but screen readers hear nothing useful.
        GestureDetector(
          onTap: () {},
          child: const Text('My latest post'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// After running `sfix fix --path example/real_world/ --skip-ai`, every
// violation above receives a fix:
//
//   Images   → semanticLabel: 'TODO: describe image'
//   Buttons  → tooltip: 'TODO: describe action'
//   Gestures → flagged in the report; use AI mode for automatic wrapping
//
// Replace every TODO string with a real description.
// The result is a screen fully accessible to screen reader users.
// ─────────────────────────────────────────────────────────────────────────────
