import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/models/RegistrationModel.dart';
import '../../utils/response/customResponse.dart';
import '../../utils/validator/validator_body.dart';

Future<Response> registrationHandler(Request req) async {
  final supabase = SupabaseClass().supabaseGet;

  try {
    final body = json.decode(await req.readAsString());

    validatorBody(body: body, keyBody: ['name', 'email', 'password', 'phone']);

    final userAuth = await supabase.auth.admin.createUser(
        AdminUserAttributes(email: body['email'], password: body['password']));
    print("-------1-----");
    await supabase.from('users').insert({
      'name': body['name'],
      'id_auth': userAuth.user!.id,
      'email': body['email'],
      'phone': body['phone'],
    });
    print("-------2-----");
    await supabase.auth.signInWithOtp(email: body['email']);
    print("-------3-----");
    return customResponse(
        state: StateResponse.ok,
        msg: 'Account successfully, confirm registration',
        dataMsg: {
          "email": userAuth.user!.email,
        });
  } on AuthException catch (error) {
    print(error);
    return customResponse(state: StateResponse.forbidden, msg: error.message);
  } on PostgrestException catch (error) {
    print(error);
    return customResponse(state: StateResponse.forbidden, msg: error.message);
  } catch (error) {
    print(error);
    return customResponse(
        state: StateResponse.badRequest,
        msg:
            "The request body must contain [name, phone, password, email] as string");
  }
}
