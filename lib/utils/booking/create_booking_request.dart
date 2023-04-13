import 'dart:convert';
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:http/http.dart' as http;

createOccupationRequest(DateTime start, DateTime end, int workspace_id) async {
  final String url = '$HOST_NAME/api/v1/workspaces_requests/';

  String? token = await get_token();
  RetrieveRoles user = await get_user();

  final Map<String, dynamic> requestMap = {
    "occupation_start_date": start.toIso8601String(),
    "occupation_end_date": end.toIso8601String(),
    "request_type": "Temporal occupation",
    "employee": user.person.id,
    "workspace": workspace_id
  };

  final response = await http.post(Uri.parse(url),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: jsonEncode(requestMap));

  if (response.statusCode == 201) {
    print('Запрос успешно отправлен!');
  } else {
    print('Ошибка отправки запроса: ${response.reasonPhrase}');
  }
}