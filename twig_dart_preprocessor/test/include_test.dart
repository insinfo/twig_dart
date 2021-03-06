import 'package:essential_code_buffer/essential_code_buffer.dart';
import 'package:essential_symbol_table/essential_symbol_table.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:twig_dart/twig_dart.dart' as twig;
import 'package:twig_dart_preprocessor/twig_dart_preprocessor.dart' as twig;

import 'package:test/test.dart';

main() {
  late FileSystem fileSystem;

  setUp(() {
    fileSystem = new MemoryFileSystem();

    // a.jl
    fileSystem.file('a.jl').writeAsStringSync('<b>a.jl</b>');

    // b.jl
    fileSystem.file('b.jl').writeAsStringSync('<i><include src="a.jl"></i>');

    // c.jl
    fileSystem.file('c.jl').writeAsStringSync('<u><include src="b.jl"></u>');
  });

  test('includes are expanded', () async {
    var file = fileSystem.file('c.jl');
    var original = twig.parseDocument(await file.readAsString(),
        sourceUrl: file.uri, onError: (e) => throw (e is Exception ? e : e as Error))!;
    var processed = await twig.resolveIncludes(
        original, fileSystem.directory(fileSystem.currentDirectory), (e) => throw (e is Exception ? e : e as Error));
    var buf = new CodeBuffer();
    var scope = new SymbolTable();
    const twig.Renderer().render(processed, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<u>
  <i>
    <b>
      a.jl
    </b>
  </i>
</u>
'''
            .trim());
  });
}
