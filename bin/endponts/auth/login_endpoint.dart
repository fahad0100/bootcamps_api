import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/response/customResponse.dart';
import '../../utils/validator/validator_body.dart';

Future<Response> loginHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;

    final body = json.decode(await req.readAsString());

    validatorBody(body: body, keyBody: ['email', "password"]);

    final user = await supabase.auth
        .signInWithPassword(password: body['password'], email: body['email']);
    await supabase.auth.signInWithOtp(email: body['email']);

    return customResponse(
        state: StateResponse.ok,
        msg: 'login successfully, confirm login',
        dataMsg: {
          "email": user.user!.email,
        });
  } on AuthException catch (error) {
    return customResponse(
      state: StateResponse.badRequest,
      msg: error.message,
    );
  } on FormatException catch (error) {
    return customResponse(
      state: StateResponse.forbidden,
      msg: error.message,
    );
  } catch (error) {
    return customResponse(
      state: StateResponse.badRequest,
      msg: 'not ',
    );
  }
}
