import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/loading_screen.dart';
import 'package:diplom_mobile_app/core/widgets/main_navigation_drawer.dart';
import 'package:diplom_mobile_app/utils/locations/locations.dart';
import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';

import 'package:flutter/material.dart';

import 'locations/locations_list.dart';
import 'office_detail/office_update_create.dart';


class OfficesScreen extends StatefulWidget{

  OfficesScreen.without_screen_title(){}

  @override
  State<OfficesScreen> createState() => OfficesScreenState();

}

class OfficesScreenState extends State<OfficesScreen> {

  bool is_loading = false;
  String title = "Офисы";

  Future<List<LocationsOfficeSchema>> _fetchLocations() async {
    // Здесь должен быть ваш код для загрузки данных
    // Например, вызов функции get_locations_with_offices()
    return get_locations_with_offices();
  }
  refresh_list() async {
    setState(() {
      is_loading =true;
    });
    // Здесь вызывается метод для обновления данных
    // Например, можно использовать setState для изменения состояния экрана
    await _fetchLocations();
    setState(() {
      is_loading = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Добавить новый офис',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OfficeUpdateCreate()),
              );
            },
          ),
        ],
      ),
      drawer: MainNavigationDrawer(),
      body:
          Stack(
            children: [
              if(!is_loading)
              Center(
                child:  FutureBuilder<List<LocationsOfficeSchema>>(
                  future: _fetchLocations(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error has occurred!'),
                      );
                    } else if (snapshot.hasData) {
                      return LocationsOfficeList(
                        locationsOffice: snapshot.data!,
                        callback: refresh_list,
                      );
                    } else {
                      return LoadingScreen();
                    }
                  },
                ),
              ),
              if(is_loading)
                LoadingScreen()
            ],
          )
    );
  }

}