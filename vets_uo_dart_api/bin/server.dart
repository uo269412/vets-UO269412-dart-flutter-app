import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vets_uo_dart_api/db_manager.dart';
import 'package:vets_uo_dart_api/routers/user_Router.dart';

import 'dart:convert';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.

   final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Cascade().add(_router).add(userRouter).handler);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}


