import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/button_style.dart';
import 'package:diplom_mobile_app/core/widgets/input_widget.dart';
import 'package:diplom_mobile_app/screens/auth/login_screen.dart';
import 'package:diplom_mobile_app/screens/offices/offices_screen.dart';
import 'package:diplom_mobile_app/utils/auth/auth.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// Define a custom Form widget.
class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}



class RegisterScreenState extends State<RegisterScreen> {

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final departmentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteBackground,
      body:
        Center(
          child:  Padding(
            padding: EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Регистрация",
                        style: TextStyle(
                          color: ColorConstants.darkGreenHeaderText,
                          fontSize: 30,
                        ),
                      ),
                      InputWidget('Имя ', firstNameController),
                      InputWidget('Фамилия', lastNameController),
                      InputWidget("email", emailController, 'email'),
                      InputWidget("Отдел", departmentController),
                      InputWidget("Логин", loginController),
                      InputWidget('Пароль', passwordController, 'password'),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:  ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              try{
                                await register(
                                    loginController.text,
                                    passwordController.text,
                                    emailController.text,
                                    firstNameController.text,
                                    lastNameController.text,
                                    departmentController.text
                                );
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OfficesScreen.without_screen_title())
                                );
                              }
                              on BadRequestException catch (_){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      "Ошибка при регистрации. Проверьте введённые данные."
                                  )),
                                );
                              }
                            }
                          },
                          style: default_style,
                          child: const Text('Зарегистрироваться'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                          onPressed: (){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen())
                            );
                          },
                          child: Text('Уже есть аккаунт? Войти!'),
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
        )



    );
  }

}