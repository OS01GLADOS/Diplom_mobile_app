import 'dart:convert';

import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/booking/booking_schema.dart';
import 'package:http/http.dart' as http;

Future<List<Booking>> get_bookings() async {

  String? token =  await get_token();
  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/workspaces_requests/'),
    headers: {'Authorization': '$token'},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return jsonData.map((data) => Booking.fromJson(data)).toList();
  } else {
    throw Exception('Failed to fetch bookings');
  }
}