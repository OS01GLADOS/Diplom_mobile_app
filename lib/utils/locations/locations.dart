import 'dart:convert';
import 'dart:io';

import "package:collection/collection.dart";
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/auth/jwt_storage.dart';
import 'package:diplom_mobile_app/utils/offices/offices.dart';
import 'package:diplom_mobile_app/utils/offices/offices_schema.dart';
import 'package:http/http.dart' as http;

import 'locations_schema.dart';

Future<List<LocationsSchema>> get_all_locations() async {
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/locations/locations-information/'),
    headers: {
      HttpHeaders.authorizationHeader: token!,
    },
  );

  final parsed =
      jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed
      .map<LocationsSchema>((json) => LocationsSchema.fromJson(json))
      .toList();
}

Future<List<LocationsOfficeSchema>> get_locations_with_offices() async {
  List<LocationsSchema> locations = await get_all_locations();
  List<OfficesSchema> offices = await get_all_offices();

  var res = <LocationsOfficeSchema>[];

  var officeMap = groupBy(offices, (OfficesSchema obj) => obj.location);
  locations.forEach((element) => {
        res.add(LocationsOfficeSchema(
            id: element.id,
            country_name: element.country_name,
            city: element.city,
            offices: officeMap[element.id]))
      });

  return res;
}
