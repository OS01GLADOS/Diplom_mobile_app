import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/constants/password_length.dart';
import 'package:deskFinder/core/widgets/button_style.dart';
import 'package:deskFinder/core/widgets/input_frame.dart';
import 'package:deskFinder/core/widgets/input_widget.dart';
import 'package:deskFinder/screens/auth/register_screen.dart';
import 'package:deskFinder/screens/offices/offices_screen.dart';
import 'package:deskFinder/utils/auth/auth.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// Define a custom Form widget.
class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => LoginScreenState();
}



class LoginScreenState extends State<LoginScreen> {

  final loginController = TextEditingController();
  final passwordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteBackground,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Войти",
              style: TextStyle(
                  color: ColorConstants.darkGreenHeaderText,
                  fontSize: 30,
              ),
            ),
            InputFrameWidget(
              'Логин',
              TextFormField(
                controller: loginController,
                validator: (value) {
                  final loginRegExp = RegExp(r"^[a-zA-Z0-9_]+$");
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите логин';
                  } else if (!loginRegExp.hasMatch(value)) {
                    return 'Логин должен содержать только буквы и цифры';
                  }
                  return null;
                },
              ),
            ),
            InputFrameWidget(
              'Пароль',
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  } else if (value.length < PASSWORD_LEN) {
                    return 'Пароль должен быть не менее $PASSWORD_LEN символов';
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
              child:  ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    try{
                      await login(loginController.text, passwordController.text);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  OfficesScreen.without_screen_title())
                      );
                    }
                    on BadRequestException catch (_){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            "Неверные логин или пароль"
                        )),
                      );
                    }
                  }
                },
                style: default_style,
                child: const Text('Войти'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                RegisterScreen())
                    );
                  },
                child: Text('Регистрация'),
              ),
            )
          ],
        )
      ),
    );
  }

}