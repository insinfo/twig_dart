import 'dart:io';
import 'package:charcode/charcode.dart';
import 'package:essential_code_buffer/essential_code_buffer.dart';
import 'package:essential_symbol_table/essential_symbol_table.dart';

import 'package:twig_dart/twig_dart.dart' as twig_dart;

main() {
  while (true) {
    var buf = StringBuffer();
    int ch;
    print('Enter lines of twig_dart text, terminated by CTRL^D.');
    print('All environment variables are injected into the template scope.');

    while ((ch = stdin.readByteSync()) != $eot && ch != -1) {
      buf.writeCharCode(ch);
    }

    var document = twig_dart.parseDocument(
      buf.toString(),
      sourceUrl: 'stdin',
      onError: stderr.writeln,
    );

    if (document == null) {
      stderr.writeln('Could not parse the given text.');
    } else {
      var output = CodeBuffer();
      const twig_dart.Renderer().render(
        document,
        output,
        SymbolTable(values: Platform.environment),
        strictResolution: false,
      );
      print('GENERATED HTML:\n$output');
    }
  }
}
