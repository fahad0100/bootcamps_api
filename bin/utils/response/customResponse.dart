import 'dart:convert';

import 'package:shelf/shelf.dart';

customResponse(
    {required StateResponse state, required String msg, dynamic dataMsg}) {
  final Map<String, dynamic> response = {"msg": msg, "data": dataMsg ?? {}};
  switch (state) {
    case StateResponse.ok:
      return Response.ok(json.encode({...response, "codeState": 200}),
          headers: {'Content-Type': 'application/json'});
    case StateResponse.forbidden:
      return Response.forbidden(
          json.encode(
            {...response, "codeState": 403},
          ),
          headers: {'Content-Type': 'application/json'});
    case StateResponse.badRequest:
      return Response.badRequest(
          body: json.encode({...response, "codeState": 400}),
          headers: {'Content-Type': 'application/json'});
    case StateResponse.notFound:
      return Response.notFound(json.encode({...response, "codeState": 404}),
          headers: {'Content-Type': 'application/json'});
    case StateResponse.unauthorized:
      return Response.unauthorized(json.encode({...response, "codeState": 401}),
          headers: {'Content-Type': 'application/json'});

    default:
      return Response.ok("body");
  }
}

enum StateResponse { forbidden, notFound, ok, badRequest, unauthorized }
