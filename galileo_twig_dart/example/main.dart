import 'dart:convert';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_twig_dart/galileo_twig_dart.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

main() async {
  var app = new Galileo();
  var http = new GalileoHttp(app);
  var fileSystem = const LocalFileSystem();

  await app.configure(
    twig(fileSystem.directory('D:\\MyDartProjects\\twig_dart\\galileo_twig_dart\\example\\views')),
  );

  app.get('/', (req, res) => res.render('index', {'title': 'Sample App', 'message': null}));

  app.post('/', (req, res) async {
    var body = await req.parseBody().then((_) => req.bodyAsMap);
    print('Body: $body');
    var msg = body['message'] ?? '<unknown>';
    return await res.render('index', {
      'title': 'Form Submission',
      'message': msg,
      'json_message': json.encode(msg),
    });
  });

  app.fallback((req, res) => throw new GalileoHttpException.notFound());

  app.logger = new Logger('galileo')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
