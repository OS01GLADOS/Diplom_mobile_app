import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/confirm_delete.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:diplom_mobile_app/utils/locations/locations.dart';
import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.locationsOffice.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () {
                  // показываем меню при долгом нажатии на элемент
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
