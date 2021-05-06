import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_twig_dart/galileo_twig_dart.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:file/memory.dart';
import 'package:html/parser.dart' as html;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

main() {
  // These tests need not actually test that the preprocessor or renderer works,
  // because those packages are already tested.
  //
  // Instead, just test that we can render at all.
  TestClient client;

  setUp(() async {
    var app = new Galileo();
    app.configuration['properties'] = app.configuration;

    var fileSystem = new MemoryFileSystem();
    var viewsDirectory = fileSystem.directory('views')..createSync();

    viewsDirectory.childFile('layout.twig').writeAsStringSync('''
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <block name="content">
      Fallback content
    </block>
  </body>
</html>
    ''');

    viewsDirectory.childFile('github.twig').writeAsStringSync('''
<extend src="layout.twig">
  <block name="content">{{username}}</block>
</extend>
    ''');

    app.get('/github/:username', (req, res) {
      var username = req.params['username'];
      return res.render('github', {'username': username});
    });

    await app.configure(
      twig(viewsDirectory),
    );

    app.fallback((req, res) => throw new GalileoHttpException.notFound());

    app.logger = new Logger('galileo')
      ..onRecord.listen((rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      });

    client = await connectTo(app);
  });

  test('can render', () async {
    var response = await client.get(Uri.parse('/github/thosakwe'));
    print('Body:\n${response.body}');
    expect(
        html.parse(response.body).outerHtml,
        html
            .parse('''
<html>
  <head>
    <title>
      Hello
    </title>
  </head>
  <body>
    thosakwe
  </body>
</html>'''
                .trim())
            .outerHtml);
  });
}
