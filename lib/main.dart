import 'package:diplom_mobile_app/screens/auth/login_screen.dart';
import 'package:diplom_mobile_app/screens/offices/offices_screen.dart';
import 'package:flutter/material.dart';

import 'core/constants/color_constants.dart';
import 'core/widgets/main_navigation_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Office spacing',
      //home: OfficesScreen.without_screen_title(),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
