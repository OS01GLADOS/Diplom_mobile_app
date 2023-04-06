import 'package:diplom_mobile_app/core/widgets/confirm_delete.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:diplom_mobile_app/utils/offices/offices.dart';
import 'package:flutter/material.dart';

import '../../utils/offices/offices_schema.dart';
import 'office_list_item.dart';

class OfficesList extends StatelessWidget {
  OfficesList({required this.offices});

  final List<OfficesSchema> offices;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: offices.length,
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
                        title: Text('Удалить офис'),
                        onTap: () async {
                          try{
                            bool confirm = await confirmDelete(context);
                            if (confirm) {
                              await deleteOffice(offices[index].id);
                              //await deleteLocation(locationsOffice[index].id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Успешно удалено'),
                                duration: Duration(seconds: 2),
                              ));
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
            child: OfficesListItem(office: offices[index]),
          );
        },
      ),
    );
  }
}
