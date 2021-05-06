import 'dart:async';

import 'package:file/file.dart';
import 'package:twig_dart/twig_dart.dart' as twig;
import 'package:twig_dart_preprocessor/twig_dart_preprocessor.dart' as twig;

Future<twig.Document?> process(twig.Document doc, Directory dir, errorHandler(e)) {
  return twig.resolve(doc, dir, onError: errorHandler, patch: [
    (doc, dir, onError) {
      print(doc!.root.children.length);
      return doc;
    },
  ]);
}
