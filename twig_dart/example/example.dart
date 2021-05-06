import 'package:essential_code_buffer/essential_code_buffer.dart';
import 'package:essential_symbol_table/essential_symbol_table.dart';
import 'package:twig_dart/twig_dart.dart' as twig_dart;

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
  var document = twig_dart.parseDocument(template, sourceUrl: 'test.twig', asDSX: false)!;

  /*
   var file = viewsDirectory.childFile(name + fileExtension);
        var contents = await file.readAsString();
        var doc = parseDocument(contents, sourceUrl: file.uri, asDSX: asDSX == true, onError: errors.add);
         */
  var scope = SymbolTable(values: {
    'profile': {
      'avatar': 'thosakwe.png',
    }
  });

  const twig_dart.Renderer().render(document, buf, scope);
  print(buf);
}
