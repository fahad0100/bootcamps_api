import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/Token/getToken.dart';
import '../../utils/models/TokenModel.dart';
import '../../utils/response/customResponse.dart';
import '../../utils/validator/validator_body.dart';

Future<Response> updatePasswordHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;
    final body = json.decode(await req.readAsString());
    validatorBody(body: body, keyBody: ['password']);
    final TokenModel token = getToken(request: req);
    final UserResponse user = await supabase.auth.admin.updateUserById(
        token.id!,
        attributes: AdminUserAttributes(
            password: body['password'], email: token.email));

    return customResponse(
        state: StateResponse.ok,
        msg: 'update successfully',
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
