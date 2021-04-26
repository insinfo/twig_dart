# twig_dart


A simple server-side HTML templating engine for Dart.


# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  twig_dart: ^2.0.0
```

# API
The core `twig_dart` package exports classes for parsing twig_dart templates,
an AST library, and a `Renderer` class that generates HTML on-the-fly.

```dart
import 'package:code_buffer/code_buffer.dart';
import 'package:twig_dart/twig_dart.dart' as twig_dart;
import 'package:symbol_table/symbol_table.dart';

void myFunction() {
    const template = '''
<html>
  <body>
    <h1>Hello</h1>
    <img src=profile['avatar']>
  </body>
</html>
''';

    var buf = CodeBuffer();
    var document = twig_dart.parseDocument(template, sourceUrl: 'test.twig', asDSX: false);
    var scope = SymbolTable(values: {
      'profile': {
        'avatar': 'thosakwe.png',
      }
    });

    const twig_dart.Renderer().render(document, buf, scope);
    print(buf);
}
```

Pre-processing (i.e. handling of blocks and includes) is handled
by `package:twig_dart_preprocessor.`.
