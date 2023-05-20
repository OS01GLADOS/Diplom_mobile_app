import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/widgets/loading_screen.dart';
import 'package:deskFinder/core/widgets/main_navigation_drawer.dart';
import 'package:deskFinder/utils/locations/locations.dart';
import 'package:deskFinder/utils/locations/locations_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/is_admin.dart';
import 'package:deskFinder/utils/retrieve_roles/is_manager.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';

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
  bool is_admin_here = false;

  @override
  initState() {
    super.initState();
        ()async{
      RetrieveRoles user = await get_user();
      setState(() {
        is_admin_here = is_admin(user.permissions);
      });
    }();

  }

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
          if(is_admin_here)
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