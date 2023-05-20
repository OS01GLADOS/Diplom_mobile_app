import 'dart:convert';
import 'dart:io';

import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;
import 'employee_schema.dart';

Future<List<Employee>> get_all_employees() async {
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/employees/'),
    headers: {
      HttpHeaders.authorizationHeader: token!,
    },
  );

  var results = utf8.decode(response.bodyBytes);
  final parsed =
  jsonDecode(results).cast<String,dynamic>();
  var to_parse = parsed['results'];
  return to_parse
      .map<Employee>((json) => Employee.fromJson(json))
      .toList();
}
