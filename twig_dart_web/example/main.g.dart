// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JaelComponentGenerator
// **************************************************************************

abstract class _HelloTwigTemplate implements Component<dynamic> {
  DateTime get now;
  @override
  DomNode render() {
    return h('div', {}, [
      h('h1', {}, [text('Hello, twig!')]),
      h('i', {}, [text('Current time: '), text(now.toString())])
    ]);
  }
}
