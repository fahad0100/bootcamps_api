
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../../env/supabase.dart';
import '../../../utils/Token/getToken.dart';
import '../../../utils/models/TokenModel.dart';
import '../../../utils/response/customResponse.dart';



Future<Response> aboutHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;

    final TokenModel token = getToken(request: req);
    final userData = await supabase
        .from('users')
        .select<List<Map<String, dynamic>>>(
            'id, name, email, title_position, phone, location, birthday, about, image, create_at')
        .eq('id_auth', token.id);
    return customResponse(
      state: StateResponse.ok,
      msg: 'successfully',
      dataMsg: userData.first,
    );
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
