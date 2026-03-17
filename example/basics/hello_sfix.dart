// ─────────────────────────────────────────────────────────────────────────────
// basics/hello_sfix.dart
//
// The simplest possible SemantiFix example.
//
// This file has TWO violations:
//   1. Image.network — missing `semanticLabel`  (MissingSemanticLabel)
//   2. IconButton    — missing `tooltip`         (MissingTooltip)
//
// HOW TO RUN:
//   sfix scan --path example/basics/              # see violations
//   sfix fix  --path example/basics/ --dry-run    # preview fixes
//   sfix fix  --path example/basics/ --skip-ai    # apply stub fixes
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

class Icon extends Widget {
  const Icon(Object icon) : super();
}

abstract class Icons {
  static const Object star = 'star';
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

// ─────────────────────────────────────────────────────────────────────────────
// The widget below has accessibility violations.
// Run `sfix fix --path example/basics/` to fix them automatically.
// ─────────────────────────────────────────────────────────────────────────────

class WelcomeCard extends StatelessWidget {
  const WelcomeCard() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✗ VIOLATION — screen readers cannot describe this image.
        //   SemantiFix will add: semanticLabel: 'Welcome banner image'
        Image.network('https://example.com/welcome-banner.png'),

        const Text('Welcome to the app!'),

        // ✗ VIOLATION — tap target has no accessible name.
        //   SemantiFix will add: tooltip: 'Mark as favourite'
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.star),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AFTER running `sfix fix --path example/basics/ --skip-ai`, the file becomes:
//
//   Image.network(
//     'https://example.com/welcome-banner.png',
//     semanticLabel: 'TODO: describe image',
//   ),
//
//   IconButton(
//     onPressed: () {},
//     icon: const Icon(Icons.star),
//     tooltip: 'TODO: describe action',
//   ),
//
// Replace the TODO strings with real descriptions and you're done!
// ─────────────────────────────────────────────────────────────────────────────
