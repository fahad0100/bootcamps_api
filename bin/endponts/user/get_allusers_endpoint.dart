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
    List dataDisplay = [];

    for (var i = 0; i < resulte.length; i++) {
      print(resulte[i]['id']);
      final List<Map<String, dynamic>> socialMedia = (await supabase
          .from('social_media')
          .select<List<Map<String, dynamic>>>()
          .eq('user_id', resulte[i]['id']));
      final List<Map<String, dynamic>> skills = (await supabase
          .from('skills')
          .select<List<Map<String, dynamic>>>()
          .eq('user_id', resulte[i]['id']));

      final List<Map<String, dynamic>> projects = (await supabase
          .from('projects')
          .select<List<Map<String, dynamic>>>()
          .eq('user_id', resulte[i]['id']));
      final List<Map<String, dynamic>> education = (await supabase
          .from('education')
          .select<List<Map<String, dynamic>>>()
          .eq('user_id', resulte[i]['id']));
      Map user = {
        ...resulte[i],
        "education": education,
        "skills": skills,
        "socialMedia": socialMedia,
        "projects": projects,
      };
      dataDisplay.add(user);
    }

    return customResponse(
        state: StateResponse.ok, msg: 'get successfully', dataMsg: dataDisplay);
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
          ? "social should be one of this 'facebook','youtube', 'whatsapp', 'instagram', 'twitter', 'tiktok', 'telegram', 'snapchat','other'"
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
