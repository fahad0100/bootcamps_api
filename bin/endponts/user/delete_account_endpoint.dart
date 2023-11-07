

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/Token/getToken.dart';
import '../../utils/models/TokenModel.dart';
import '../../utils/response/customResponse.dart';

Future<Response> deleteAccountHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;
    final TokenModel token = getToken(request: req);
    final userID = (await supabase
            .from('users')
            .select<List<Map<String, dynamic>>>('id')
            .eq('id_auth', token.id))
        .first['id'];
    await supabase.from('projects').delete().eq("user_id", userID);
    await supabase.from('skills').delete().eq("user_id", userID);
    await supabase.from('social_media').delete().eq("user_id", userID);
    await supabase.from('users').delete().eq("id", userID);
    await supabase.auth.admin.deleteUser(token.id.toString());
    return customResponse(
        state: StateResponse.ok,
        msg: 'deleted successfully',
        dataMsg: {
          "email": "user.user!.email",
        });
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
  } catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.badRequest,
      msg: 'not ',
    );
  }
}
