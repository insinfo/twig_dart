import 'package:galileo_framework/galileo_framework.dart';
import 'package:essential_code_buffer/essential_code_buffer.dart';
import 'package:file/file.dart';
import 'package:twig_dart/twig_dart.dart';
import 'package:twig_dart_preprocessor/twig_dart_preprocessor.dart';
import 'package:essential_symbol_table/essential_symbol_table.dart';

/// Configures an Galileo server to use twig to render templates.
///
/// To enable "minified" output, you need to override the [createBuffer] function,
/// to instantiate a [CodeBuffer] that emits no spaces or line breaks.
///
/// To apply additional transforms to parsed documents, provide a set of [patch] functions.
GalileoConfigurer twig(Directory viewsDirectory,
    {String fileExtension,
    bool strictResolution: false,
    bool cacheViews: false,
    Iterable<Patcher> patch,
    bool asDSX: false,
    CodeBuffer createBuffer()}) {
  var cache = <String, Document>{};
  fileExtension ??= '.twig';
  createBuffer ??= () => new CodeBuffer();

  return (Galileo app) async {
    app.viewGenerator = (String name, [Map locals]) async {
      var errors = <TwigDartError>[];
      Document processed;

      if (cacheViews == true && cache.containsKey(name)) {
        processed = cache[name];
      } else {
        var file = viewsDirectory.childFile(name + fileExtension);
        var contents = await file.readAsString();
        var doc = parseDocument(contents, sourceUrl: file.uri, asDSX: asDSX == true, onError: errors.add);
        processed = doc;

        try {
          processed = await resolve(doc, viewsDirectory, patch: patch, onError: (e) => errors.add(e as TwigDartError));
        } catch (_) {
          // Ignore these errors, so that we can show syntax errors.
        }

        if (cacheViews == true) {
          cache[name] = processed;
        }
      }

      var buf = createBuffer();
      var scope = new SymbolTable(
          values: locals?.keys
                  ?.fold<Map<String, dynamic>>(<String, dynamic>{}, (out, k) => out..[k.toString()] = locals[k]) ??
              <String, dynamic>{});

      if (errors.isEmpty) {
        try {
          const Renderer().render(processed, buf, scope, strictResolution: strictResolution == true);
          return buf.toString();
        } on TwigDartError catch (e) {
          errors.add(e);
        }
      }

      Renderer.errorDocument(errors, buf..clear());
      return buf.toString();
    };
  };
}
