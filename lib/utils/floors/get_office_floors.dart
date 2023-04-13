import 'dart:convert';
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;

import 'floor_schema.dart';

Future<List<GetFloorModel>> get_office_floors(int office_id) async {
  String? token = await get_token();

  final url = Uri.parse('$HOST_NAME/api/v1/offices/$office_id/floors-statistic/');
  final response = await http.get(
    url,
    headers: {
      'Authorization': '$token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> floorsJson = jsonDecode(response.body);
    return floorsJson.map((json) => GetFloorModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load floors');
  }
}