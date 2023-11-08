import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../endponts/auth/registration_endpont.dart';
import '../endponts/user/about/about_endpont.dart';
import '../endponts/user/about/edit_about_endpont.dart';
import '../endponts/user/delete_account_endpoint.dart';
import '../endponts/user/education/add_Education_endpont.dart';
import '../endponts/user/education/delete_education_endpont.dart';
import '../endponts/user/education/get_education_endpoint.dart';
import '../endponts/user/get_allusers_endpoint.dart';
import '../endponts/user/get_users_by_id_endpoint copy.dart';
import '../endponts/user/project/add_project_endpoint.dart';
import '../endponts/user/project/delete_project_endpoint.dart';
import '../endponts/user/project/get_projects_endpoint.dart';
import '../endponts/user/skills/add_skills_endpoint.dart';
import '../endponts/user/social/add_socialMedia_endpont.dart';
import '../endponts/user/skills/delete_skills_endpoint.dart';
import '../endponts/user/social/delete_social_media_endpont.dart';
import '../endponts/user/skills/get_skills_endpoint.dart';
import '../endponts/user/social/get_socialMedia_endpoint.dart';
import '../endponts/user/update_password_endpoint.dart';
import '../endponts/user/upload_image_endpoint.dart';
import '../utils/Middelwares/checkToken.dart';

class UserRoute {
  Handler get route {
    final router = Router()
      ..put('/update_password', updatePasswordHandler)
      ..get('/about', aboutHandler)
      ..put('/edit/about', editAboutHandler)
      //-----
      ..get('/social_media', getSocialMediaHandler)
      ..post('/add/social_media', addSocialMediaHandler)
      ..delete('/delete/social_media', deleteSocialMediaHandler)
      //-----
      ..get('/skills', getSkillsHandler)
      ..post('/add/skills', addSkillsHandler)
      ..delete('/delete/skills', deleteSkillsHandler)
      //-----
      ..get('/get_users', getAllUsersHandler)
      //-----
      ..get('/projects', getProjectHandler)
      ..post('/add/project', addProjectHandler)
      ..delete('/delete/project', deleteProjectHandler)
      //-----
      ..post('/add/education', addEducationMediaHandler)
      ..delete('/delete/education', deleteEducationMediaHandler)
      ..get('/education', getEducationMediaHandler)
      //-----
      ..delete('/delete_account', deleteAccountHandler)
      ..get('/<id>', getByIDHandler)
      ..post('/upload', imageProfileHandler);

    //p----------not -----

    //----------------------------------------

    //p-------not--------

    final pipeline =
        Pipeline().addMiddleware(checkToken()).addHandler(router.call);

    return pipeline;
  }
}
