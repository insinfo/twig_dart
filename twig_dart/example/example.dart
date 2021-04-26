import 'package:code_buffer/code_buffer.dart';
import 'package:twig_dart/twig_dart.dart' as twig_dart;
import 'package:symbol_table/symbol_table.dart';

void main(List<String> args) {
  const template = '''
<html>
  <body>
    <h1>Hello</h1>
    <img src=profile['avatar']>
  </body>
</html>
''';

  var buf = CodeBuffer();
  var document = twig_dart.parseDocument(template, sourceUrl: 'test.twig_dart', asDSX: false);
  var scope = SymbolTable(values: {
    'profile': {
      'avatar': 'thosakwe.png',
    }
  });

  const twig_dart.Renderer().render(document, buf, scope);
  print(buf);
}
