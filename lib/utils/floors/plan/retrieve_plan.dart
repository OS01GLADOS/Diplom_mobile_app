import 'dart:convert';
import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/floors/plan/rooms_schema.dart';
import 'package:http/http.dart' as http;


Future<List<Room>> get_floor_rooms(int office_id) async {
  String? token = await get_token();

  final url = Uri.parse('$HOST_NAME/api/v1/floors/$office_id/retrieve-room-list/');
  final response = await http.get(
    url,
    headers: {
      'Authorization': '$token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> floorsJson = jsonDecode(response.body);
    return floorsJson.map((json) => Room.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load floors');
  }
}