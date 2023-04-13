import 'dart:io';
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

Future<File?> pickSvgFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['svg'],
  );
  if (result != null) {
    return File(result.files.single.path!);

  } else {
    return null;
  }
}


Future<void> sendSvgFile(int floor_id) async {
  File? svgFile = await pickSvgFile();
  if(svgFile == null)
    return;
  String? token = await get_token();
  var url = Uri.parse('$HOST_NAME/api/v1/floors/$floor_id/create-plan/');
  var request = http.MultipartRequest('PATCH', url)
    ..headers['Authorization'] = '$token'
    ..files.add(await http.MultipartFile.fromPath('layout', svgFile.path))
    ..fields['floor_width'] = '10'
    ..fields['floor_height'] = '1';

  var response = await request.send();
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Error uploading file');
  }
}