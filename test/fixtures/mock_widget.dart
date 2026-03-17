// Standalone Flutter-like stubs — no Flutter SDK needed.
// These stub classes let the fixture be valid Dart so the analyzer can resolve it.

class Widget {
  const Widget();
}

class BuildContext {}

class StatelessWidget extends Widget {
  const StatelessWidget({Widget? key}) : super();
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
}

class Text extends Widget {
  const Text(String data) : super();
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

class Semantics extends Widget {
  const Semantics({Widget? child, String? label}) : super();
}

class GestureDetector extends Widget {
  const GestureDetector({void Function()? onTap, Widget? child}) : super();
}

class FloatingActionButton extends Widget {
  const FloatingActionButton({
    required void Function() onPressed,
    Widget? child,
    String? tooltip,
  }) : super();
}

class InkWell extends Widget {
  const InkWell({void Function()? onTap, Widget? child}) : super();
}

// ── Fixture widget with 5 intentional violations ──────────────────────────

class MockWidget extends StatelessWidget {
  const MockWidget({required this.url}) : super();

  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Violation 1: Image.network missing semanticLabel
        Image.network(url),

        // Violation 2: IconButton missing tooltip
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),

        // Violation 3: GestureDetector not wrapped in Semantics
        GestureDetector(
          onTap: () {},
          child: const Text('Tap me'),
        ),

        // Violation 4: FloatingActionButton missing tooltip
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),

        // Violation 5: InkWell not wrapped in Semantics
        InkWell(
          onTap: () {},
          child: const Text('Tap me'),
        ),
      ],
    );
  }
}
