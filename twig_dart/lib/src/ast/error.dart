import 'package:source_span/source_span.dart';

class TwigDartError extends Error {
  final TwigDartErrorSeverity severity;
  final String message;
  final FileSpan span;

  TwigDartError(this.severity, this.message, this.span);

  @override
  String toString() {
    var label = severity == TwigDartErrorSeverity.warning ? 'warning' : 'error';
    return '$label: ${span.start.toolString}: $message\n' + span.highlight(color: true);
  }
}

enum TwigDartErrorSeverity {
  warning,
  error,
}
