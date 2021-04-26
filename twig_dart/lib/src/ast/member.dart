import 'dart:mirrors';
import 'package:essential_symbol_table/essential_symbol_table.dart';
import 'package:source_span/source_span.dart';

import 'expression.dart';
import 'identifier.dart';
import 'token.dart';

class MemberExpression extends Expression {
  final Expression expression;
  final Token op;
  final Identifier name;

  MemberExpression(this.expression, this.op, this.name);

  @override
  compute(SymbolTable scope) {
    var target = expression.compute(scope);
    if (op.span.text == '?.' && target == null) return null;
    return reflect(target).getField(Symbol(name.name)).reflectee;
  }

  @override
  FileSpan get span => expression.span.expand(op.span).expand(name.span);
}
