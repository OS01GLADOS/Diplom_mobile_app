import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';
import 'package:flutter/material.dart';

import 'offices_list.dart';

class LocationsListItem extends StatelessWidget {
  LocationsListItem({ required this.locationsOffice});

  final LocationsOfficeSchema locationsOffice;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
          locationsOffice.country_name + ", "+ locationsOffice.city,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: ColorConstants.darkGreenHeaderText,
        ),
      ),
        children: [
          (locationsOffice.offices == null) ? Text("нет офисов") :
          OfficesList(offices: locationsOffice.offices!)
        ],
    );
  }
}