import 'package:shelf_router/shelf_router.dart';

import '../endponts/auth/login_endpoint.dart';
import '../endponts/auth/registration_endpont.dart';
import '../endponts/auth/restpassword_endpont.dart';
import '../endponts/auth/verification_endpoint.dart';
import '../endponts/root_endpoint.dart';
import 'user_route.dart';

class MainRoute {
  Router get route {
    final router = Router()
      ..get('/', rootHandler)
      ..post('/auth/registration', registrationHandler)
      ..post('/auth/verification', verificationHandler)
      ..post('/auth/login', loginHandler)
      ..post('/auth/rest_password', restPasswordHandler)
      ..mount('/user', UserRoute().route);
    return router;
  }
}
