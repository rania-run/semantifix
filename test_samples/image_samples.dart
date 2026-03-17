// Flutter stubs — no Flutter SDK needed.
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
  const Text(String d) : super();
}

class Icon extends Widget {
  const Icon(Object i) : super();
}

abstract class Icons {
  static const Object add = 'add';
  static const Object edit = 'edit';
}

class Semantics extends Widget {
  const Semantics({Widget? child, String? label}) : super();
}

class Image extends Widget {
  const Image({String? semanticLabel}) : super();
  const Image.asset(String p, {String? semanticLabel}) : super();
  const Image.network(String u, {String? semanticLabel}) : super();
}

class IconButton extends Widget {
  const IconButton(
      {required void Function() onPressed,
      required Widget icon,
      String? tooltip})
      : super();
}

class FloatingActionButton extends Widget {
  const FloatingActionButton(
      {required void Function() onPressed, Widget? child, String? tooltip})
      : super();
}

class GestureDetector extends Widget {
  const GestureDetector({void Function()? onTap, Widget? child}) : super();
}

class InkWell extends Widget {
  const InkWell({void Function()? onTap, Widget? child}) : super();
}

// VIOLATION: Image() missing semanticLabel
const v1 = Image();

// VIOLATION: Image.asset missing semanticLabel
const v2 = Image.asset('assets/logo.png');

// VIOLATION: Image.network missing semanticLabel
const v3 = Image.network('https://example.com/photo.png');

// OK: Image.network with semanticLabel
const ok1 =
    Image.network('https://example.com/photo.png', semanticLabel: 'A photo');
