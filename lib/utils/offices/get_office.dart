import 'dart:convert';
import 'dart:io';

import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/offices/get_office_schema.dart';
import 'package:http/http.dart' as http;



Future<Office> get_office(int id) async {
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/offices/$id/'),
    headers: {
      HttpHeaders.authorizationHeader: token!,
    },
  );
  var res = jsonDecode(utf8.decode(response.bodyBytes));
  res['location'] = res['location']['id'];
  res['owner'] = res['owner']['id'];

  if (res.containsKey('manager')) {
    res['manager'] = res['manager']
        .where((manager) => manager != null)
        .map((manager) => manager['id'])
        .where((id) => id != res['owner'])
        .toSet()
        .toList();
  } else {
    res['manager'] = [];
  }
  return Office.fromJson(res);
}