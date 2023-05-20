import 'dart:convert';
import 'dart:io';

import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
import 'package:http/http.dart' as http;

retrieve_roles_me() async{
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/employees/retrieve-roles/me/'),
     headers: {
    HttpHeaders.authorizationHeader: token!,
    },
  );

  final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
  RetrieveRoles UserRole = RetrieveRoles.fromJson(responseJson);
  await set_user(UserRole);
}