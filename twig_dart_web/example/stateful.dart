import 'dart:async';
import 'package:twig_dart_web/twig_dart_web.dart';
part 'stateful.g.dart';

void main() {}

class _AppState {
  final int ticks;

  _AppState({this.ticks});

  _AppState copyWith({int ticks}) {
    return _AppState(ticks: ticks ?? this.ticks);
  }
}

@Twig(template: '<div>Tick count: {{state.ticks}}</div>')
class StatefulApp extends Component<_AppState> with _StatefulAppTwigTemplate {
  Timer _timer;

  StatefulApp() {
    state = _AppState(ticks: 0);
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(state.copyWith(ticks: t.tick));
    });
  }

  @override
  void beforeDestroy() {
    _timer.cancel();
  }
}
