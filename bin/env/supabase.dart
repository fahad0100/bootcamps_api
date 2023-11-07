import 'package:supabase/supabase.dart';
import 'package:dotenv/dotenv.dart';

class SupabaseClass {
  SupabaseClient get supabaseGet {
    try {
      var env = DotEnv(includePlatformEnvironment: true)..load();
      final supabase =
          SupabaseClient(env['URLSUBAPASE']!, env['SECRITSUBAPASE']!);
      return supabase;
    } catch (error) {
      throw FormatException(
          'error >> ::: there is error from configuration supabase ');
    }
  }
}
