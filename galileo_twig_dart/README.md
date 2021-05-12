# galileo_twig_dart 
[![Pub](https://img.shields.io/pub/v/galileo_twig.svg)](https://pub.dartlang.org/packages/galileo_twig_dart)
[![build status](https://travis-ci.org/galileo-dart/twig.svg)](https://travis-ci.org/galileo-dart/twig)


[galileo](https://galileodart.com)
support for
[twig](https://github.com/insinfo/twig_dart).

# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  galileo_twig_dart : ^3.0.2
```

# Usage
Just like `mustache` and other renderers, configuring galileo to use
twig is as simple as calling `app.configure`:

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_twig/galileo_twig.dart';
import 'package:file/file.dart';

galileoConfigurer myPlugin(FileSystem fileSystem) {
    return (galileo app) async {
        // Connect twig to your server...
        await app.configure(
        twig(fileSystem.directory('views')),
      );
    };
}
```

`package:galileo_twig` supports caching views, to improve server performance.
You might not want to enable this in development, so consider setting
the flag to `app.isProduction`:

```
twig(viewsDirectory, cacheViews: app.isProduction);
```

Keep in mind that this package uses `package:file`, rather than
`dart:io`.

The following is a basic example of a server setup that can render twig
templates from a directory named `views`:

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_twig/galileo_twig.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

main() async {
  var app = new galileo();
  var fileSystem = const LocalFileSystem();

  await app.configure(
    twig(fileSystem.directory('views')),
  );

  // Render the contents of views/index.twig
  app.get('/', (res) => res.render('index', {'title': 'ESKETTIT'}));

  app.use(() => throw new galileoHttpException.notFound());

  app.logger = new Logger('galileo')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  var server = await app.startServer(null, 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
```

To apply additional transforms to parsed documents, provide a
set of `patch` functions, like in `package:twig_preprocessor`.