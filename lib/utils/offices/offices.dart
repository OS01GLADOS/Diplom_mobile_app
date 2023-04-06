import 'dart:convert';
import 'dart:io';

import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:http/http.dart' as http;

import 'offices_schema.dart';


Future<List<OfficesSchema>> get_all_offices() async{
  String? token = await get_token();


  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/offices/office-statistic/'),
    headers: {
      HttpHeaders.authorizationHeader: token!,
    },
  );

  final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed.map<OfficesSchema>((json) => OfficesSchema.fromJson(json)).toList();
}


deleteOffice(int id) async {
  String? token = await get_token();

  try {
    final response = await http.delete(
      Uri.parse('$HOST_NAME/api/v1/offices/$id/'),
      headers: {
        HttpHeaders.authorizationHeader: token!,
      },
    );
    print(response.body);
    if (response.statusCode == 204) {
      print('Office deleted successfully.');
    } else {
      throw BadRequestException(utf8.decode(response.bodyBytes));
    }
  } on BadRequestException catch (e) {
    // parse the JSON payload
    final Map<String, dynamic> responseJson = json.decode(e.toString());

    // extract the "message" field from the payload
    final String errorMessage = responseJson['message'];

    // throw a new BadRequestException with the extracted message
    throw BadRequestException(errorMessage);
  } catch (e) {
    throw BadRequestException(e.toString());
  }
}
