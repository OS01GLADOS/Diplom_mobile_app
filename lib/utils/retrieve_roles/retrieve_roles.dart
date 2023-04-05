import 'dart:convert';
import 'dart:io';

import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:http/http.dart' as http;

retrieve_roles_me() async{
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/employees/retrieve-roles/me/'),
     headers: {
    HttpHeaders.authorizationHeader: token!,
    },
  );

  final responseJson = jsonDecode(response.body);
  RetrieveRoles UserRole = RetrieveRoles.fromJson(responseJson);
  await set_user(UserRole);
}