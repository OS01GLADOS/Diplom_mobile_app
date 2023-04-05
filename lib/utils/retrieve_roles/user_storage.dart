

import 'dart:convert';

import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';

const user_key = "user_roles_info";

Future<RetrieveRoles> get_user() async{
  var user_data = await storage.read(key: user_key);
  return RetrieveRoles.fromJson(jsonDecode(user_data!));
}

set_user(RetrieveRoles user) async{
  String data = jsonEncode(user);
  await storage.write(key: user_key, value: data);
}

delete_user() async{
  await storage.delete(key: user_key);
}