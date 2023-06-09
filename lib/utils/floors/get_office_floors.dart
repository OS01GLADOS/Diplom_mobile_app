import 'dart:convert';
import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
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
    var res = floorsJson.map((json) => GetFloorModel.fromJson(json)).toList();
    res.sort((a, b) => a.number.compareTo(b.number));
    return res;
  } else {
    throw Exception('Failed to load floors');
  }
}