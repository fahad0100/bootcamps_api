import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../models/TokenModel.dart';

TokenModel getToken({required Request request}) {
  Map<String, dynamic> header = request.headers;

  var token = (header["Authorization"] ?? header["authorization"]).toString();
  if (token.startsWith("Bearer ")) {
    token = token.substring(7, token.length);
  }
  final userToken = JWT.decode(token);

  return TokenModel.fromJson(json: userToken.payload);
}
