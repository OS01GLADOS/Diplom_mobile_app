import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/main_navigation_drawer.dart';
import 'package:diplom_mobile_app/utils/locations/locations.dart';
import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';

import 'package:flutter/material.dart';

import 'locations_list.dart';


class OfficesScreen extends StatefulWidget{

  OfficesScreen.without_screen_title(){}

  @override
  State<OfficesScreen> createState() => OfficesScreenState();

}



class OfficesScreenState extends State<OfficesScreen> {

  OfficesScreenState([this.title = 'Офисы']);

  String title = "Офисы";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(title),
      ),
      drawer: MainNavigationDrawer(),
      body: Center(
        child:  FutureBuilder<List<LocationsOfficeSchema>>(
          future: get_locations_with_offices(),

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              return LocationsOfficeList(locationsOffice: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

}