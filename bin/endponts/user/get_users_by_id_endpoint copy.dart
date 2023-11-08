import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../env/supabase.dart';
import '../../utils/Token/getToken.dart';
import '../../utils/models/TokenModel.dart';
import '../../utils/response/customResponse.dart';

Future<Response> getByIDHandler(Request req) async {
  return Response.ok("body");
}
