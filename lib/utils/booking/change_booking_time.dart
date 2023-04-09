import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'booking_schema.dart';

changeBookingDate(DateTime start, DateTime end, Booking booking) async {
  final String url = '$HOST_NAME/api/v1/workspaces_requests/${booking.id}/'; // замените на ваш URL
  final Map<String, dynamic> requestBody = {
    "occupation_start_date": start.toIso8601String(),
    "occupation_end_date": end.toIso8601String(),
    "request_type": booking.requestType,
    "employee": booking.employeeId,
    "workspace": booking.workspaceId
  };
  final String? token = await get_token(); // замените на ваш токен авторизации
  final http.Response response = await http.patch(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '$token',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    print('Успешный запрос: ${response.body}');
  } else {
    print('Ошибка запроса: ${response.statusCode}');
  }
}