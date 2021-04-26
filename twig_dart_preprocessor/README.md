# twig_dart_preprocessor


# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  twig_dart_preprocessor: ^2.0.1
```

# Usage
It is unlikely that you will directly use this package, as it is
more of an implementation detail than a requirement. However, it
is responsible for handling `include` and `block` directives
(template inheritance), so you are a package maintainer and want
to support twig, read on.

To keep things simple, just use the `resolve` function, which will
take care of inheritance for you.

```dart
import 'package:twig_dart_preprocessor/twig_dart_preprocessor.dart' as twig;

myFunction() async {
  var doc = await parseTemplateSomehow();
  var resolved = await twig.resolve(doc, dir, onError: (e) => doSomething());
}
```

You may occasionally need to manually patch in functionality that is not
available through the official twig packages. To achieve this, simply
provide an `Iterable` of `Patcher` functions:

```dart
myOtherFunction(twig.Document doc) {
  return twig.resolve(doc, dir, onError: errorHandler, patch: [
    syntactic(),
    sugar(),
    etc(),
  ]);
}
```

**This package uses `package:file`, rather than `dart:io`.**