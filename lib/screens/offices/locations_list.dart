import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';
import 'package:flutter/material.dart';

import 'location_list_item.dart';

class LocationsOfficeList extends StatelessWidget {
  LocationsOfficeList({ required this.locationsOffice});

  final List<LocationsOfficeSchema> locationsOffice;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locationsOffice.length,
      itemBuilder: (context, index) {
        return LocationsListItem(locationsOffice: locationsOffice[index]);
      },
    );
  }
}