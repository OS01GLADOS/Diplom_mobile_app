import 'dart:convert';
import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/floors/plan/plan_objects.dart';
import 'package:deskFinder/utils/floors/plan/rooms_schema.dart';
import 'package:deskFinder/utils/floors/plan/stairs_schema.dart';
import 'package:http/http.dart' as http;



Future<PlanObjects> get_floor_rooms(int office_id) async {
  String? token = await get_token();

  final url = Uri.parse('$HOST_NAME/api/v1/floors/$office_id/retrieve-plan/');
  final response = await http.get(
    url,
    headers: {
      'Authorization': '$token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> floorsJson = jsonDecode(response.body)['rooms'];
    final List<dynamic> stairsJson =  jsonDecode(response.body)['stairs'];
    PlanObjects plan = PlanObjects(rooms: floorsJson.map((json) => Room.fromJson(json)).toList(), stairs:stairsJson.map((json) => Stair.fromJson(json)).toList());
    return plan;
  } else {
    throw Exception('Failed to load floors');
  }
}