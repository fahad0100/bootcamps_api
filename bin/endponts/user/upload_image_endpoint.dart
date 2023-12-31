import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../env/supabase.dart';
import '../../utils/Token/getToken.dart';
import '../../utils/models/TokenModel.dart';
import '../../utils/response/customResponse.dart';

// Directory to store uploaded files

Future<Response> imageProfileHandler(Request request) async {
  final contentLength = int.tryParse(request.headers['content-length'] ?? '0');

  if (contentLength == 0) {
    return Response(HttpStatus.badRequest, body: 'No file provided');
  }
  final uploadDirectory = Directory('uploads');
  if (!uploadDirectory.existsSync()) {
    uploadDirectory.createSync();
  }
  final multipart = request.read();
  final fileName =
      '${DateTime.now().millisecondsSinceEpoch}.png'; // Example: Use a timestamp as the filename

  final file = File('${uploadDirectory.path}/$fileName');

  try {
    await file.create();

    final fileSink = file.openWrite();
    await for (var chunk in multipart) {
      fileSink.add(chunk);
    }
    await fileSink.close();
    print("=========");
    print(await file.length());
    print("=========");
    double fileSize =
        double.parse((file.lengthSync() / 1024 / 1024).toStringAsFixed(2));
    if (fileSize > 0.5) {
      return Response.internalServerError(
          body: 'file should be less then 0.5 MB');
    }
    final supabase = SupabaseClass().supabaseGet;
    final TokenModel token = getToken(request: request);
    final userID = (await supabase
            .from('users')
            .select<List<Map<String, dynamic>>>('id')
            .eq('id_auth', token.id))
        .first['id'];
    final list = await supabase.storage.from('profile').list(path: 'profile/');
    bool isFound = false;
    final nameImage = 'profile/$userID${DateTime.now()}.png';
    for (var element in list) {
      if (element.name.startsWith(userID.toString())) {
        isFound = true;
        print(element.name);
        await supabase.storage
            .from('profile')
            .remove(['profile/${element.name}']);
      }
    }
    if (!isFound) {
      await supabase.storage.from('profile').upload(nameImage, file);
    } else {
      await supabase.storage.from('profile').upload(nameImage, file);
    }

    final url1 = supabase.storage.from('profile').getPublicUrl(nameImage);
    await supabase
        .from('users')
        .update({'image': url1}).eq('id_auth', token.id);

    // You can save file information to a database, serve it, or process it as needed.
    // Replace this with your own logic.

    return customResponse(
        state: StateResponse.ok,
        msg: 'uploaded successfully',
        dataMsg: {
          "email": url1,
        });
  } catch (e) {
    print('Error while uploading: $e');
    return Response.internalServerError(body: 'Failed to upload file');
  }
}
