import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:supabase/supabase.dart';

import 'env/supabase.dart';
import 'routes/main_route.dart';

void main(List<String> args) async {
  // withHotreload(
  //   () async => await createServer(),
  //   onReloaded: () => print('Reload!'),
  //   onHotReloadNotAvailable: () => print('No hot-reload :('),
  //   onHotReloadAvailable: () => print('Yay! Hot-reload :)'),
  //   onHotReloadLog: (log) => print('Reload Log: ${log.message}'),
  //   logLevel: Level.INFO,
  // );

  // final supabase = SupabaseClass().supabaseGet;

  // List<User> users = await supabase.auth.admin.listUsers();
  // for (var element in users) {
  //   print("------");
  //   print(element.id);
  //   await supabase.auth.admin.deleteUser(element.id);
  // }

  await createServer();
}

createServer() async {
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(MainRoute().route.call);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on  http://${server.address.host}:${server.port}');
  return server;
}
