import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/confirm_delete.dart';
import 'package:diplom_mobile_app/core/widgets/main_navigation_drawer.dart';
import 'package:diplom_mobile_app/utils/booking/booking_schema.dart';
import 'package:diplom_mobile_app/utils/booking/get_bookings.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:flutter/material.dart';

import 'booking_item.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({Key? key, required this.title}) : super(key: key);
  BookingsScreen.without_screen_title(): this.title = "Запросы";
  final String title;

  bool is_manager = true;
  List<int> bookings = [4, 8, 12, 16, 23, 42];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(title),
      ),
      drawer: MainNavigationDrawer(),
      body: Column(
        children: <Widget>[
          FutureBuilder<List<Booking>>(
            future: get_bookings(),
            builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Ошибка: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                final bookings = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return
                      InkWell(
                        onLongPress: () {
                          // показываем меню при долгом нажатии на элемент
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: is_manager?
                                [
                                  //approve
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Одобрить запрос'),
                                    onTap: () async {
                                      try {
                                        bool confirm = await confirmDelete(context);
                                        if (confirm) {
                                          //todo reject action
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Успешно одобрено'),
                                            duration: Duration(seconds: 2),
                                          ));
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
                                  //reject
                                  ListTile(
                                    leading: Icon(Icons.clear),
                                    title: Text('Отклонить запрос'),
                                    onTap: () async {
                                      try {
                                        bool confirm = await confirmDelete(context);
                                        if (confirm) {
                                          //todo reject action
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Успешно отклонено'),
                                            duration: Duration(seconds: 2),
                                          ));
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

                                ]:
                                [
                                  //change request time
                                  ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Изменить время бронирования'),
                                      onTap: () async {
                                        Navigator.of(context).pop(true);

                                      }
                                  ),
                                  //delete
                                  (
                                      bookings[index] == 4
                                  ) ?
                                  ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Удалить запрос'),
                                    onTap: () async {
                                      try {
                                        bool confirm = await confirmDelete(context);
                                        if (confirm) {
                                          //todo delete action
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Успешно удалено'),
                                            duration: Duration(seconds: 2),
                                          ));
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
                                  ) :
                                  //delay
                                  ListTile(
                                    leading: Icon(Icons.clear),
                                    title: Text('Отменить запрос'),
                                    onTap: () async {
                                      try {
                                        bool confirm = await confirmDelete(context);
                                        if (confirm) {
                                          //todo delay action
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Успешно отменено'),
                                            duration: Duration(seconds: 2),
                                          ));
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
                                ]
                                ,
                              );
                            },
                          );
                        },
                        child: BookingItemWidget(
                          key: ValueKey(bookings[index].id),
                          booking: bookings[index],
                        ),
                      );
                  },
                );
              } else {
                return Center(
                  child: Text("Нет данных"),
                );
              }
            },
          ),
        ],
      ),
    );
  }

}