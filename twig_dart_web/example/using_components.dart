import 'package:twig_dart_web/twig_dart_web.dart';
part 'using_components.g.dart';

@Twig(template: '''
<div>
  <h1>Welcome to my app</h1>
  <LabeledInput name="username" />
</div>
''')
class MyApp extends Component with _MyAppTwigTemplate {}

@Twig(template: '''
<div>
  <label>
    <b>{{name}}:</b>
  </label>
  <br>
  <input name=name placeholder="Enter " + name + "..." type="text">
</div>
''')
class LabeledInput extends Component with _LabeledInputTwigTemplate {
  final String name;

  LabeledInput({this.name});
}
