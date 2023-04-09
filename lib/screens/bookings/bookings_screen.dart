import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/confirm_action.dart';
import 'package:diplom_mobile_app/core/widgets/main_navigation_drawer.dart';
import 'package:diplom_mobile_app/utils/booking/booking_schema.dart';
import 'package:diplom_mobile_app/utils/booking/change_booking_status.dart';
import 'package:diplom_mobile_app/utils/booking/get_bookings.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

import 'booking_item.dart';
import 'change_booking_dates.dart';

class BookingsScreen extends StatefulWidget{

  BookingsScreen({Key? key, required this.title}) : super(key: key);
  BookingsScreen.without_screen_title(): this.title = "Запросы";
  final String title;

  @override
  State<BookingsScreen> createState() => BookingsScreenState();

}


class BookingsScreenState extends State<BookingsScreen> {


  // find if user is manager

  bool is_manager = false;


  @override
  initState() {
    super.initState();
        ()async{
      RetrieveRoles user = await get_user();
      setState(() {
        is_manager = user.permissions.contains("WORKSPACE-REQUEST_APPROVE");

      });
    }();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(widget.title),
      ),
      drawer: MainNavigationDrawer(),
      body:
    RefreshIndicator(
    onRefresh: () async {
    // Здесь вызывается метод для обновления данных
    // Например, можно использовать setState для изменения состояния экрана
    await get_bookings();
    setState(() {});
    },
      child:       Column(
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
                                        bool confirm = await confirmAction(context, "Вы уверены, что хотите одобрить запрос?");
                                        if (confirm) {
                                          await approve_request(bookings[index].id);
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
                                        setState(() {});
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
                                        bool confirm = await confirmAction(context, "Вы уверены, что хотите отклонить запрос?");
                                        if (confirm) {
                                          await reject_request(bookings[index].id);
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
                                        setState(() {});
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
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => BookingScreenDate(booking: bookings[index] ,)));
                                      }
                                  ),
                                  //delay
                                  ListTile(
                                    leading: Icon(Icons.clear),
                                    title: Text('Отменить запрос'),
                                    onTap: () async {
                                      try {
                                        bool confirm = await confirmAction(context, "Вы уверены, что хотите отменить запрос?");
                                        if (confirm) {
                                          await delay_request(bookings[index].id);
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
                                        setState(() {});
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
    )


    );
  }

}