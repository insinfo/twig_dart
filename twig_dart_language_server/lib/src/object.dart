import 'dart:collection';

import 'package:source_span/source_span.dart';

abstract class twigObject {
  final FileSpan span;
  final usages = <SymbolUsage>[];
  String get name;

  twigObject(this.span);
}

class twigCustomElement extends twigObject {
  final String name;
  final attributes = new SplayTreeSet<String>();

  twigCustomElement(this.name, FileSpan span) : super(span);
}

class twigVariable extends twigObject {
  final String name;
  twigVariable(this.name, FileSpan span) : super(span);
}

class SymbolUsage {
  final SymbolUsageType type;
  final FileSpan span;

  SymbolUsage(this.type, this.span);
}

enum SymbolUsageType { definition, read }
