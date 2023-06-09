import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/screens/auth/login_screen.dart';
import 'package:deskFinder/screens/bookings/bookings_screen.dart';
import 'package:deskFinder/screens/offices/offices_screen.dart';
import 'package:deskFinder/utils/auth/auth.dart';
import 'package:deskFinder/utils/retrieve_roles/is_admin.dart';
import 'package:deskFinder/utils/retrieve_roles/is_manager.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

class MainNavigationDrawer extends StatefulWidget{

  @override
  State<MainNavigationDrawer> createState() => MainNavigationDrawerState();

}


class MainNavigationDrawerState extends State<MainNavigationDrawer> {


  bool is_manager_here = false;
  bool is_admin_here = false;

  @override
  initState() {
    super.initState();
    ()async{
      RetrieveRoles user = await get_user();
      setState(() {
        is_manager_here = is_manager(user.permissions);
        is_admin_here = is_admin(user.permissions);
        employee_name = user.person.preferred_name;
        employee_role = user.person.department;
      });
    }();

  }

  String employee_name = "";
  String employee_role = "";

  @override
  Widget build(BuildContext context) => Drawer(
          child: Container(
        color: ColorConstants.lightGreen,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      ));

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 30,
          left: 24,
          right: 24,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (is_admin_here)
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.diamond_outlined,
                        size: 20,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      employee_name,
                      style: TextStyle(
                          color: ColorConstants.whiteBackground,
                          fontSize: 20),
                    ),
                  ),

                ],
              ),
            ),
            Text(
              "$employee_role department",
              style: TextStyle(
                  color: ColorConstants.whiteBackground, fontSize: 15),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            Divider(
              color: ColorConstants.whiteBackground,
            ),
            ListTile(
                leading: Icon(
                  Icons.business,
                  color: ColorConstants.whiteBackground,
                ),
                title: Text(
                  'Офисы',
                  style: TextStyle(color: ColorConstants.whiteBackground),
                ),
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            OfficesScreen.without_screen_title()))),
            Divider(
              color: ColorConstants.whiteBackground,
            ),
            ListTile(
              leading: Icon(
                Icons.assignment_outlined,
                color: ColorConstants.whiteBackground,
              ),
              title: Text(
                'Запросы на бронирование',
                style: TextStyle(color: ColorConstants.whiteBackground),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        BookingsScreen.without_screen_title()));
              },
            ),
            Divider(
              color: ColorConstants.whiteBackground,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: ColorConstants.whiteBackground,
              ),
              title: Text(
                'Выйти',
                style: TextStyle(color: ColorConstants.whiteBackground),
              ),
              onTap: () async {
                await logout();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false
                );
              },
            ),
          ],
        ),
      );
}
