// ─────────────────────────────────────────────────────────────────────────────
// images/image_gallery.dart
//
// Demonstrates the MissingSemanticLabel violation across all three
// Image constructor variants: Image(), Image.asset(), Image.network()
//
// Violations in this file: 3× MissingSemanticLabel
//
// HOW TO RUN:
//   sfix scan --path example/images/
//   sfix fix  --path example/images/ --dry-run --skip-ai
//   sfix fix  --path example/images/ --skip-ai
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

class Image extends Widget {
  const Image({String? semanticLabel}) : super();
  const Image.asset(String path, {String? semanticLabel}) : super();
  const Image.network(String url, {String? semanticLabel}) : super();
}

// ─────────────────────────────────────────────────────────────────────────────

/// A gallery screen showing three image styles, all with missing semanticLabel.
///
/// Without `semanticLabel`, screen readers skip over these images entirely —
/// users relying on VoiceOver or TalkBack get no information about what
/// the images show.
class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. Image() — generic constructor ─────────────────────────────────
        //
        // ✗ VIOLATION: missing semanticLabel
        //
        // What SemantiFix adds (AI mode):
        //   semanticLabel: 'Decorative hero image'
        //
        // What SemantiFix adds (--skip-ai):
        //   semanticLabel: 'TODO: describe image'
        const Image(),

        // ── 2. Image.asset() — local asset ───────────────────────────────────
        //
        // ✗ VIOLATION: missing semanticLabel
        //
        // What SemantiFix adds (AI mode):
        //   semanticLabel: 'App logo'
        //
        // What SemantiFix adds (--skip-ai):
        //   semanticLabel: 'TODO: describe image'
        const Image.asset('assets/images/logo.png'),

        // ── 3. Image.network() — remote image ────────────────────────────────
        //
        // ✗ VIOLATION: missing semanticLabel
        //
        // What SemantiFix adds (AI mode):
        //   semanticLabel: 'Photo uploaded by the user'
        //
        // What SemantiFix adds (--skip-ai):
        //   semanticLabel: 'TODO: describe image'
        Image.network('https://example.com/gallery/photo-1.jpg'),

        // ── OK example — this one is already accessible ───────────────────────
        //
        // ✓ No violation — semanticLabel is present.
        //   SemantiFix will leave this line unchanged.
        Image.network(
          'https://example.com/gallery/photo-2.jpg',
          semanticLabel: 'Mountain landscape at sunset',
        ),
      ],
    );
  }
}
