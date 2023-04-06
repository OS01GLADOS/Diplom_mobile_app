import 'dart:convert';

import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:http/http.dart' as http;

import 'auth_schema.dart';

logout() async {
  await delete_token();
  await delete_user();
}

login(String username, String password) async {
  Map data = {"username": username, "password": password};

  final response = await http.post(
    Uri.parse('$HOST_NAME/api/v1/auth/login/'),
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    Token token_data =  Token.fromJson(jsonDecode(response.body));
    await set_token(token_data.token);
  } else {
    throw BadRequestException(response.body.toString());
  }

  await retrieve_roles_me();
}

register(
    String username,
    String password,
    String email,
    String firstName,
    String lastName,
    String department
    )
async {
  Map data = {
    "username":username,
    "password":password,
    "email":email,
    "firstName":firstName,
    "lastName":lastName,
    "department":department
  };
  final response = await http.post(
    Uri.parse('$HOST_NAME/api/v1/auth/register/'),
    body: json.encode(data),
  );

  if (response.statusCode == 201) {
    Token token_data =  Token.fromJson(jsonDecode(response.body));
    await set_token(token_data.token);
  } else {
    throw BadRequestException(response.body.toString());
  }
  await retrieve_roles_me();
}
