import 'package:essential_code_buffer/essential_code_buffer.dart';
import 'package:essential_symbol_table/essential_symbol_table.dart';
import 'package:twig_dart/twig_dart.dart' as twig;

import 'package:test/test.dart';

main() {
  test('attribute binding', () {
    const template = '''
<html>
  <body>
    <h1>Hello</h1>
    <img ready="always" data-img-src=profile['avatar'] />
    <input name="csrf_token" type="hidden" value=csrf_token>
  </body>
</html>
''';

    var buf = CodeBuffer();
    twig.Document? document;
    late SymbolTable scope;

    try {
      document = twig.parseDocument(template, sourceUrl: 'test.twig');
      scope = SymbolTable<dynamic>(values: {
        'csrf_token': 'foo',
        'profile': {
          'avatar': 'thosakwe.png',
        }
      });
    } on twig.TwigDartError catch (e) {
      print(e);
      print(e.stackTrace);
    }

    expect(document, isNotNull);
    const twig.Renderer().render(document!, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Hello
    </h1>
    <img ready="always" data-img-src="thosakwe.png">
    <input name="csrf_token" type="hidden" value="foo">
  </body>
</html>
    '''
            .trim());
  });

  test('interpolation', () {
    const template = '''
<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <body>
    <h1>Pokémon</h1>
    {{ pokemon.name }} - {{ pokemon.type }}
    <img>
  </body>
</html>
''';

    var buf = CodeBuffer();
    //twig.scan(template, sourceUrl: 'test.twig').tokens.forEach(print);
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable<dynamic>(values: {
      'pokemon': const _Pokemon('Darkrai', 'Dark'),
    });

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString().replaceAll('\n', '').replaceAll(' ', '').trim(),
        '''
<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <body>
    <h1>
      Pokémon
    </h1>
    Darkrai - Dark
    <img/>
  </body>
</html>
    '''
            .replaceAll('\n', '')
            .replaceAll(' ', '')
            .trim());
  });

  test('for loop', () {
    const template = '''
<html>
  <body>
    <h1>Pokémon</h1>
    <ul>
      <li for-each=starters as="starter" index-as="idx">#{{ idx }} {{ starter.name }} - {{ starter.type }}</li>
    </ul>
  </body>
</html>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable<dynamic>(values: {
      'starters': starters,
    });

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Pokémon
    </h1>
    <ul>
      <li>
        #0 Bulbasaur - Grass
      </li>
      <li>
        #1 Charmander - Fire
      </li>
      <li>
        #2 Squirtle - Water
      </li>
    </ul>
  </body>
</html>
    '''
            .trim());
  });

  test('conditional', () {
    const template = '''
<html>
  <body>
    <h1>Conditional</h1>
    <b if=starters.isEmpty>Empty</b>
    <b if=starters.isNotEmpty>Not empty</b>
  </body>
</html>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable<dynamic>(values: {
      'starters': starters,
    });

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Conditional
    </h1>
    <b>
      Not empty
    </b>
  </body>
</html>  
    '''
            .trim());
  });

  test('declare', () {
    const template = '''
<div>
 <declare one=1 two=2 three=3>
   <ul>
    <li>{{one}}</li>
    <li>{{two}}</li>
    <li>{{three}}</li>
   </ul>
   <ul>
    <declare three=4>
      <li>{{one}}</li>
      <li>{{two}}</li>
      <li>{{three}}</li>
    </declare>
   </ul>
 </declare>
</div>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable();

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<div>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      3
    </li>
  </ul>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      4
    </li>
  </ul>
</div>
'''
            .trim());
  });

  test('unescaped attr/interp', () {
    const template = '''
<div>
  <img src!="<SCARY XSS>" />
  {{- "<MORE SCARY XSS>" }}
</div>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable();

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString().replaceAll('\n', '').replaceAll(' ', '').trim(),
        '''
<div>
  <img src="<SCARY XSS>">
  <MORE SCARY XSS>
</div>
'''
            .replaceAll('\n', '')
            .replaceAll(' ', '')
            .trim());
  });

  test('quoted attribute name', () {
    const template = '''
<button '(click)'="myEventHandler(\$event)"></button>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable();

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<button (click)="myEventHandler(\$event)">
</button>
'''
            .trim());
  });

  test('switch', () {
    const template = '''
<switch value=account.isDisabled>
  <case value=true>
    BAN HAMMER LOLOL
  </case>
  <case value=false>
    You are in good standing.
  </case>
  <default>
    Weird...
  </default>
</switch>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable<dynamic>(values: {
      'account': _Account(isDisabled: true),
    });

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(buf.toString().trim(), 'BAN HAMMER LOLOL');
  });

  test('default', () {
    const template = '''
<switch value=account.isDisabled>
  <case value=true>
    BAN HAMMER LOLOL
  </case>
  <case value=false>
    You are in good standing.
  </case>
  <default>
    Weird...
  </default>
</switch>
''';

    var buf = CodeBuffer();
    var document = twig.parseDocument(template, sourceUrl: 'test.twig')!;
    var scope = SymbolTable<dynamic>(values: {
      'account': _Account(isDisabled: null),
    });

    const twig.Renderer().render(document, buf, scope);
    print(buf);

    expect(buf.toString().trim(), 'Weird...');
  });
}

const List<_Pokemon> starters = [
  _Pokemon('Bulbasaur', 'Grass'),
  _Pokemon('Charmander', 'Fire'),
  _Pokemon('Squirtle', 'Water'),
];

class _Pokemon {
  final String name, type;

  const _Pokemon(this.name, this.type);
}

class _Account {
  final bool? isDisabled;

  _Account({this.isDisabled});
}
