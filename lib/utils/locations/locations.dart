import 'dart:convert';
import 'dart:io';

import "package:collection/collection.dart";
import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
import 'package:deskFinder/utils/locations/rus_to_translit.dart';
import 'package:deskFinder/utils/offices/offices.dart';
import 'package:deskFinder/utils/offices/offices_schema.dart';
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

deleteLocation(int id) async {
  String? token = await get_token();

  try {
    final response = await http.delete(
      Uri.parse('$HOST_NAME/api/v1/locations/$id/'),
      headers: {
        HttpHeaders.authorizationHeader: token!,
      },
    );
    if (response.statusCode == 204) {
      print('Location deleted successfully.');
    } else {
      throw BadRequestException(utf8.decode(response.bodyBytes));
    }
  } on BadRequestException catch (e) {
    // parse the JSON payload
    final Map<String, dynamic> responseJson = json.decode(e.toString());

    // extract the "message" field from the payload
    final String errorMessage = responseJson['message'];

    // throw a new BadRequestException with the extracted message
    throw BadRequestException(errorMessage);
  } catch (e) {
    throw BadRequestException(e.toString());
  }
}


createLocation(String country, String city) async {
  final String url = '$HOST_NAME/api/v1/locations/';
  String? token = await get_token();

  var city_eng =  transliterate(city);

  Map data = {
    'country': country,
    'city': city,
    'city_eng': city_eng
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': '$token',
      "content-type" : "application/json",
      "accept" : "application/json",
    },
    body: json.encode(data),
  );
  if (response.statusCode != 201) {
    final message = jsonDecode(response.body)['message'];
    throw BadRequestException(message);
  }
}