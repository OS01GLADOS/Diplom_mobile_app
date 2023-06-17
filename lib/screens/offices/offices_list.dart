import 'package:deskFinder/core/widgets/confirm_delete.dart';
import 'package:deskFinder/screens/offices/offices_screen.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
import 'package:deskFinder/utils/offices/offices.dart';
import 'package:deskFinder/utils/retrieve_roles/is_admin.dart';
import 'package:deskFinder/utils/retrieve_roles/is_allowed_location.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

import '../../utils/offices/offices_schema.dart';
import 'office_detail/office_detail.dart';
import 'office_detail/office_update_create.dart';
import 'office_list_item.dart';

class OfficesList extends StatefulWidget{
  OfficesList({required this.offices});

  final List<OfficesSchema> offices;

  OfficesListState createState() => OfficesListState();
}


class OfficesListState extends State<OfficesList> {

  bool is_admin_here = false;
  var allowed_locations;

  @override
  initState() {
    super.initState();
        ()async{
      RetrieveRoles user = await get_user();
      print(user.allowed_locations);
      setState(() {
        is_admin_here = is_admin(user.permissions);
        allowed_locations = user;
      });
    }();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.offices.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OfficeDetailScreen(officeId:widget.offices[index].id)),
              );
            },
            onLongPress: () {
              // показываем меню при долгом нажатии на элемент
              if(is_allowed_location(allowed_locations, widget.offices[index].id))
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if(is_admin_here)
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Удалить офис'),
                        onTap: () async {
                          try {
                            bool confirm = await confirmDelete(context);
                            if (confirm) {
                              await deleteOffice(widget.offices[index].id);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Успешно удалено'),
                                duration: Duration(seconds: 2),
                              ));
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OfficesScreen.without_screen_title(
                                  ),
                                ),
                              );
                            }
                          } on BadRequestException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Ошибка: ${e.toString()}'),
                              duration: Duration(seconds: 2),
                            ));
                          } finally {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Изменить офис'),
                        onTap: () async {
                          Navigator.of(context).pop(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OfficeUpdateCreate(office_id:widget.offices[index].id)),
                          );
                        }
                      )
                    ],
                  );
                },
              );
            },
            child: OfficesListItem(office: widget.offices[index]),
          );
        },
      ),
    );
  }
}
