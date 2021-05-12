import 'package:twig_dart_web/twig_dart_web.dart';
import 'package:twig_dart_web/elements.dart';
part 'main.g.dart';

@Twig(template: '''
<div>
  <h1>Hello, twig!</h1>
  <i>Current time: {{now}}</i>
</div>
''')
class Hello extends Component with _HelloTwigTemplate {
  DateTime get now => DateTime.now();
}

// Could also have been:
class Hello2 extends Component {
  DateTime get now => DateTime.now();

  @override
  DomNode render() {
    return div(c: [
      h1(c: [
        text('Hello, twig!'),
      ]),
      i(c: [
        text('Current time: $now'),
      ]),
    ]);
  }
}
