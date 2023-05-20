import 'package:deskFinder/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

import 'core/constants/color_constants.dart';

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
      theme: ThemeData(
        primaryColor: ColorConstants.lightGreen,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
