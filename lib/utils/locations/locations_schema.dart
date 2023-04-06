import 'package:diplom_mobile_app/utils/offices/offices_schema.dart';

class LocationsSchema {
  final int id;
  final String country_name;
  final String city;

  const LocationsSchema({
    required this.id,
    required this.country_name,
    required this.city
  });

  factory LocationsSchema.fromJson(Map<String, dynamic> json) {
    return LocationsSchema(
      id: json['id'],
      country_name: json['country_name'],
      city: json['translations'][0]['city'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'country_name': country_name,
    'city': city,
  };
}

class LocationsOfficeSchema {
  final int id;
  final String country_name;
  final String city;

  final List<OfficesSchema>? offices;

  const LocationsOfficeSchema({
    required this.id,
    required this.country_name,
    required this.city,
    required this.offices
  });
}