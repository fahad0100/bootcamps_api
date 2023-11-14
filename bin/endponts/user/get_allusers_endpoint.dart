import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/Token/getToken.dart';
import '../../utils/models/TokenModel.dart';
import '../../utils/response/customResponse.dart';

Future<Response> getAllUsersHandler(Request req) async {
  try {
    final supabase = SupabaseClass().supabaseGet;

    final TokenModel token = getToken(request: req);
    final userID = (await supabase
            .from('users')
            .select<List<Map<String, dynamic>>>('id')
            .eq('id_auth', token.id))
        .first['id'];

    final List<Map<String, dynamic>> resulte = (await supabase
        .from('users')
        .select<List<Map<String, dynamic>>>()
        .neq("id", userID));

    final table = await supabase.from('users').select<
            List<Map<String, dynamic>>>(
        '*,skills!inner(*),social_media!inner(*),education!inner(*),projects!inner(*)');
    print(table);

    //   Map user = {
    //     ...resulte[i],
    //     "education": education,
    //     "skills": skills,
    //     "socialMedia": socialMedia,
    //     "projects": projects,
    //   };
    //   dataDisplay.add(user);
    // }

    return customResponse(
        state: StateResponse.ok, msg: 'get successfully', dataMsg: table);
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
      msg: error.message,
    );
  } catch (error) {
    print(error);
    return customResponse(
      state: StateResponse.badRequest,
      msg: error.toString(),
    );
  }
}
