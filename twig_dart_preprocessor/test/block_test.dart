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
    fileSystem
        .file('b.jl')
        .writeAsStringSync('<i><include src="a.jl" /><block name="greeting"><p>Hello</p></block></i>');

    // c.jl
    // NOTE: This SHOULD NOT produce "yes", because the only children expanded within an <extend>
    // are <block>s.
    fileSystem.file('c.jl').writeAsStringSync('<extend src="b.jl"><block name="greeting">Goodbye</block>Yes</extend>');

    // d.jl
    // This should not output "Yes", either.
    // It should actually produce the same as c.jl, since it doesn't define any unique blocks.
    fileSystem.file('d.jl').writeAsStringSync('<extend src="c.jl"><block name="greeting">Saluton!</block>Yes</extend>');

    // e.jl
    fileSystem.file('e.jl').writeAsStringSync(
        '<extend src="c.jl"><block name="greeting">Galileo <b><block name="name">default</block></b></block></extend>');

    // fox.jl
    fileSystem.file('fox.jl').writeAsStringSync(
        '<div><block name="dance">The name is <block name="name">default-name</block></block></div>');

    // trot.jl
    fileSystem.file('trot.jl').writeAsStringSync(
        '<extend src="fox.jl"><block name="name">CONGA <i><block name="exclaim">YEAH</block></i></block></extend>');

    // foxtrot.jl
    fileSystem
        .file('foxtrot.jl')
        .writeAsStringSync('<extend src="trot.jl"><block name="exclaim">framework</block></extend>');
  });

  test('blocks are replaced or kept', () async {
    var file = fileSystem.file('c.jl');
    var original = twig.parseDocument(await file.readAsString(),
        sourceUrl: file.uri, onError: (e) => throw (e is Exception ? e : e as Error))!;
    var processed = await (twig.resolve(original, fileSystem.directory(fileSystem.currentDirectory),
        onError: (e) => throw (e is Exception ? e : e as Error)));

    var buf = new CodeBuffer();
    var scope = new SymbolTable();
    const twig.Renderer().render(processed as twig.Document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<i>
  <b>
    a.jl
  </b>
  Goodbye
</i>
    '''
            .trim());
  });

  test('block defaults are emitted', () async {
    var file = fileSystem.file('b.jl');
    var original = twig.parseDocument(await file.readAsString(), sourceUrl: file.uri, onError: (e) => throw e)!;
    var processed = await (twig.resolve(original, fileSystem.directory(fileSystem.currentDirectory),
        onError: (e) => throw (e is Exception ? e : e as Error)));
    var buf = new CodeBuffer();
    var scope = new SymbolTable();
    const twig.Renderer().render(processed as twig.Document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<i>
  <b>
    a.jl
  </b>
  <p>
    Hello
  </p>
</i>
    '''
            .trim());
  });

  test('block resolution only redefines blocks at one level at a time', () async {
    var file = fileSystem.file('d.jl');
    var original = twig.parseDocument(await file.readAsString(), sourceUrl: file.uri, onError: (e) => throw e)!;
    var processed = await (twig.resolve(original, fileSystem.directory(fileSystem.currentDirectory),
        onError: (e) => throw (e is Exception ? e : e as Error)));
    var buf = new CodeBuffer();
    var scope = new SymbolTable();
    const twig.Renderer().render(processed!, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<i>
  <b>
    a.jl
  </b>
  Goodbye
</i>
    '''
            .trim());
  });

  test('blocks within blocks', () async {
    var file = fileSystem.file('foxtrot.jl');
    var original = twig.parseDocument(await file.readAsString(), sourceUrl: file.uri, onError: (e) => throw e)!;
    var processed = await (twig.resolve(original, fileSystem.directory(fileSystem.currentDirectory),
        onError: (e) => throw (e is Exception ? e : e as Error)));
    var buf = new CodeBuffer();
    var scope = new SymbolTable();
    const twig.Renderer().render(processed!, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<div>
  The name is CONGA 
  <i>
    framework
  </i>
</div>
    '''
            .trim());
  });
}
