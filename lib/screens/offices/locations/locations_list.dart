import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/widgets/confirm_delete.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
import 'package:deskFinder/utils/locations/locations.dart';
import 'package:deskFinder/utils/locations/locations_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/is_admin.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

import 'location_create.dart';
import 'location_list_item.dart';


class LocationsOfficeList extends StatefulWidget {
  LocationsOfficeList({ required this.locationsOffice, required this.callback});

  final List<LocationsOfficeSchema> locationsOffice;
  final callback;


  LocationsOfficeListState createState() => LocationsOfficeListState();
}

class LocationsOfficeListState extends State<LocationsOfficeList> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.locationsOffice.length ==0)
          Expanded(child:Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.place,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Никто не добавил ни одной локации \n :(',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  if(is_admin_here)
                  Text(
                    'Нажмите на кнопку ниже, чтобы добавить локацию',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )),
        if (widget.locationsOffice.length >0)
        Expanded(
          child:


          ListView.builder(
            itemCount: widget.locationsOffice.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () {
                  // показываем меню при долгом нажатии на элемент
                  if(is_admin_here)
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Удалить локацию'),
                            onTap: () async {
                              try{
                                bool confirm = await confirmDelete(context);
                                if (confirm) {
                                  await deleteLocation(widget.locationsOffice[index].id);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Успешно удалено'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  widget.callback();
                                }
                              }on BadRequestException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Ошибка: ${e.toString()}'),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                              finally{
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: LocationsListItem(locationsOffice: widget.locationsOffice[index]),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        if(is_admin_here)
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateLocationWidget(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: ColorConstants.lightGreen,
          ),
          child: Text('Добавить локацию'),
        ),
      ],
    );
  }
}
