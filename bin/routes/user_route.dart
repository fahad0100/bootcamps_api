import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../endponts/auth/registration_endpont.dart';
import '../endponts/root_endpoint.dart';
import '../endponts/user/update_password_endpoint.dart';
import '../utils/Middelwares/checkToken.dart';

class UserRoute {
  Handler get route {
    final router = Router()
      ..put('/update_password', updatePasswordHandler)
      ..get('/me', rootHandler)
      ..get('/socialMedia', registrationHandler)
      ..get('/skills', registrationHandler)
      ..get('/project', registrationHandler)
      ..get('/resume', registrationHandler)
      ..get('/whatIdo', registrationHandler)
      ..get('/education', registrationHandler)
      ..get('/Experience', registrationHandler)
      //----------------------------------------
      ..post('/edit/me', rootHandler)
      ..post('/edit/socialMedia', registrationHandler)
      ..post('/edit/skills', registrationHandler)
      ..post('/edit/project', registrationHandler)
      ..post('/edit/resume', registrationHandler)
      ..post('/edit/whatIdo', registrationHandler)
      ..post('/edit/education', registrationHandler)
      ..post('/edit/Experience', registrationHandler);
    final pipeline =
        Pipeline().addMiddleware(checkToken()).addHandler(router.call);

    return pipeline;
  }
}
