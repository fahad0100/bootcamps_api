import 'package:shelf/shelf.dart';

Response rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}
