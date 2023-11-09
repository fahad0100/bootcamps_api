import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../../env/supabase.dart';
import '../../../utils/Token/getToken.dart';
import '../../../utils/models/TokenModel.dart';
import '../../../utils/response/customResponse.dart';
import '../../../utils/validator/validator_body.dart';

Future<Response> editAboutHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;
    final body = json.decode(await req.readAsString());
    validatorBody(body: body, keyBody: [
      'name',
      'title_position',
      'phone',
      'location',
      'birthday',
      'about'
    ]);

    final TokenModel token = getToken(request: req);
    final user = await supabase
        .from('users')
        .update(body)
        .eq('id_auth', token.id)
        .select<List<Map<String, dynamic>>>(
            'id, name, email, title_position, phone, location, birthday, about, image, create_at');
    return customResponse(
        state: StateResponse.ok,
        msg: 'update data user successfully',
        dataMsg: user.first);
  } on AuthException catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.badRequest,
      msg: error.message,
    );
  } on FormatException catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.forbidden,
      msg: error.message,
    );
  } on PostgrestException catch (error) {
    print(error);
    if (error.code == "22007") {
      return customResponse(
        state: StateResponse.badRequest,
        msg: 'The date should be similar to this formate 02/11/2001',
      );
    } else {
      return customResponse(
        state: StateResponse.badRequest,
        msg: error.message,
      );
    }
  } catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.badRequest,
      msg: 'The date should be similar to this wording 02/11/2001',
    );
  }
}
