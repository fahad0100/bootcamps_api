import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../response/customResponse.dart';

Middleware checkToken() => (innerHandler) => (Request req) async {
      try {
        Map<String, dynamic> header = req.headers;
        var token =
            (header["Authorization"] ?? header["authorization"]).toString();
        if (token.isNotEmpty) {
          if (token.startsWith("Bearer ")) {
            token = token.substring(7, token.length);
          }
          var env = DotEnv(includePlatformEnvironment: true)..load();
          JWT.verify(
            token,
            SecretKey(env['JWTSUBAPASE']!),
          );

          return innerHandler(req);
        } else {
          return customResponse(
            state: StateResponse.unauthorized,
            msg: 'Token is required',
          );
        }
      } on JWTException {
        // return ResponseCustom.error(message: "Token is expired");
        return customResponse(
          state: StateResponse.unauthorized,
          msg: 'Token is expired or invalid',
        );
      } on FormatException {
        return customResponse(
          state: StateResponse.unauthorized,
          msg: 'Token is required',
        );
      } catch (error) {
        return customResponse(
          state: StateResponse.unauthorized,
          msg: 'Token is required $error',
        );
      }
    };
