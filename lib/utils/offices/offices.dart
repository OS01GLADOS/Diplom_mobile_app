import 'dart:convert';
import 'dart:io';

import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
import 'package:deskFinder/utils/locations/rus_to_translit.dart';
import 'package:http/http.dart' as http;

import 'offices_schema.dart';

Future<List<OfficesSchema>> get_all_offices() async {
  String? token = await get_token();

  final response = await http.get(
    Uri.parse('$HOST_NAME/api/v1/offices/office-statistic/'),
    headers: {
      HttpHeaders.authorizationHeader: token!,
    },
  );

  final parsed =
      jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
  return parsed
      .map<OfficesSchema>((json) => OfficesSchema.fromJson(json))
      .toList();
}

deleteOffice(int id) async {
  String? token = await get_token();

  try {
    final response = await http.delete(
      Uri.parse('$HOST_NAME/api/v1/offices/$id/'),
      headers: {
        HttpHeaders.authorizationHeader: token!,
      },
    );
    print(response.body);
    if (response.statusCode == 204) {
      print('Office deleted successfully.');
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

officeAction(
    List<int?> managers,

    String address,
    String postcode,
    int selectedOwnerId,
    int selectedLocationId,
    List<int> floors,
    [bool is_update = false, int office_id = 0]
    ) async {

  print(managers);

  List<int?> filteredManagers = managers
      .where((manager) => manager != null) // исключаем значения null
      .toSet() // удаляем повторы
      .where((manager) => manager != selectedOwnerId) // исключаем элементы, равные selectedOwnerId
      .toList();


  if(is_update){
    await updateOffice(
        filteredManagers,
        address,
        postcode,
        selectedOwnerId,
        selectedLocationId,
        office_id,
        floors
    );
  }
  else{
    await createOffice(
        filteredManagers,
        address,
        postcode,
        selectedOwnerId,
        selectedLocationId,
        floors
    );
  }
}

updateOffice(
    List<int?> managers,
    String address,
    String postcode,
    int selectedOwnerId,
    int selectedLocationId,
    int office_id,
    List<int> floors
    ) async
{

  String? token = await get_token();
  try {

    String adress_translit = transliterate(address);

    Map data = {
      "location": selectedLocationId,
      "address": address,
      "address_eng": adress_translit,
      "postcode": postcode,
      "manager":managers,
      "owner":  selectedOwnerId,
      "floors_numbers": floors,
      "jira_office_id":0
    };

    await http.patch(
      Uri.parse('$HOST_NAME/api/v1/offices/$office_id/'),
      headers: {
        HttpHeaders.authorizationHeader: token!,
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: json.encode(data),


    );
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


createOffice(
    List<int?> managers,
    String address,
    String postcode,
    int selectedOwnerId,
    int selectedLocationId,
    List<int> floors
) async {
  String? token = await get_token();
  try {

    String adress_translit = transliterate(address);

    Map data = {
      "location": selectedLocationId,
      "address": address,
      "address_eng": adress_translit,
      "postcode": postcode,
      "manager":managers,
      "owner":  selectedOwnerId,
      "floors_numbers":floors,
      "jira_office_id":0
    };

    await http.post(
      Uri.parse('$HOST_NAME/api/v1/offices/'),
      headers: {
        HttpHeaders.authorizationHeader: token!,
        "content-type" : "application/json",
        "accept" : "application/json",

      },
      body: json.encode(data),


    );
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