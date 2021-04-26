import 'dart:async';

import 'package:file/file.dart';
import 'package:jael/jael.dart' as jael;
import 'package:twig_dart_preprocessor/twig_dart_preprocessor.dart' as jael;

Future<jael.Document> process(jael.Document doc, Directory dir, errorHandler(jael.JaelError e)) {
  return jael.resolve(doc, dir, onError: errorHandler, patch: [
    (doc, dir, onError) {
      print(doc.root.children.length);
      return doc;
    },
  ]);
}
