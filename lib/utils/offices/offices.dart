import 'dart:convert';
import 'dart:io';

import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
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
