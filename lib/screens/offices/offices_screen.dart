import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/main_navigation_drawer.dart';
import 'package:flutter/material.dart';

class OfficesScreen extends StatelessWidget {
  const OfficesScreen({Key? key, required this.title}) : super(key: key);

  OfficesScreen.without_screen_title(): this.title = "Офисы";

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(title),
      ),
      drawer: MainNavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Offices screen',
            ),
          ],
        ),
      ),
    );
  }

}