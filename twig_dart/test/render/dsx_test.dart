import 'package:essential_symbol_table/essential_symbol_table.dart';
import 'package:twig_dart/twig_dart.dart';
import 'package:test/test.dart';

void main() {
  test('attributes 2', () {
    var doc = parseDSX('''
    <foo bar="baz" yes={no} />
    ''')!;

    var foo = doc.root as SelfClosingElement;
    expect(foo.tagName.name, 'foo');
    expect(foo.attributes, hasLength(2));
    expect(foo.getAttribute('bar'), isNotNull);
    expect(foo.getAttribute('yes'), isNotNull);
    expect(foo.getAttribute('bar')!.value!.compute(null), 'baz');
    expect(foo.getAttribute('yes')!.value!.compute(SymbolTable(values: {'no': 'maybe'})), 'maybe');
  });

  test('children', () {
    var doc = parseDSX('''
    <foo bar="baz" yes={no}>
      <bar>{24 * 3}</bar>
    </foo>
    ''')!;

    var bar = doc.root.children.first as RegularElement;
    expect(bar.tagName.name, 'bar');

    var interpolation = bar.children.first as Interpolation;
    expect(interpolation.expression.compute(null), 24 * 3);
  });
}

Document? parseDSX(String text) {
  return parseDocument(text, sourceUrl: 'test.dsx', asDSX: true, onError: (e) => throw e);
}
