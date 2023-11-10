import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../../env/supabase.dart';

import '../../../utils/Token/getToken.dart';
import '../../../utils/models/TokenModel.dart';
import '../../../utils/response/customResponse.dart';
import '../../../utils/validator/validator_body.dart';

Future<Response> deleteProjectHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;

    final body = json.decode(await req.readAsString());
    validatorBody(body: body, keyBody: ['id_project']);

    final TokenModel token = getToken(request: req);
    final userID = (await supabase
            .from('users')
            .select<List<Map<String, dynamic>>>('id')
            .eq('id_auth', token.id))
        .first['id'];

    final project = await supabase
        .from("projects")
        .delete()
        .eq('id', body['id_project'])
        .eq('user_id', userID)
        .select<List<Map<String, dynamic>>>();

    return customResponse(
        state: StateResponse.ok,
        msg: 'deleted project successfully',
        dataMsg: project);
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
    print(error.code);

    return customResponse(
      state: StateResponse.badRequest,
      msg: error.code != 23514
          ? "social should be one of this 'completed','processing', 'other'"
          : error.message,
    );
  } catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.badRequest,
      msg: error.toString(),
    );
  }
}
