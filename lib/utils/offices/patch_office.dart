import 'dart:convert';
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;

Future<http.Response> patchOffice(int officeId, Map<String, dynamic> body) async {

  var token = await get_token();
  final url = '$HOST_NAME/api/v1/offices/$officeId/';
  final headers = {
    'Authorization': '$token',
    'Content-Type': 'application/json',
  };
  final jsonBody = json.encode(body);

  try {
    final response = await http.patch(Uri.parse(url), headers: headers, body: jsonBody);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Ошибка при выполнении запроса: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Ошибка сети: $e');
  } on FormatException {
    throw Exception('Ошибка формата данных');
  } catch (e) {
    throw Exception('Неизвестная ошибка: $e');
  }
}