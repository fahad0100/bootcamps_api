import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/response/customResponse.dart';
import '../../utils/validator/validator_body.dart';

Future<Response> verificationHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;
    final body = json.decode(await req.readAsString());
    validatorBody(body: body, keyBody: ['otp', 'email', 'type']);

    OtpType? type;

    switch (body["type"]) {
      case 'registration':
        type = OtpType.signup;
      case 'login':
        type = OtpType.magiclink;
      case 'rest':
        type = OtpType.recovery;
      default:
        throw FormatException("type should be (registration or login or rest)");
    }

    final verification = await supabase.auth.verifyOTP(
        token: body['otp'].toString(), type: type, email: body['email']);
    return customResponse(
        state: StateResponse.ok,
        msg: 'Verified successfully',
        dataMsg: {
          "token": verification.session!.accessToken,
          "expiresAt": verification.session!.expiresAt,
          "tokenType": verification.session!.tokenType,
          "expiresIn": verification.session!.expiresIn,
          "email": verification.user!.email,
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
      msg: error.toString(),
    );
  }
}
