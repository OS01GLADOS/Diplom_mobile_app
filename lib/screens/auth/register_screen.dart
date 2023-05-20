import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/constants/password_length.dart';
import 'package:deskFinder/core/widgets/button_style.dart';
import 'package:deskFinder/core/widgets/input_frame.dart';
import 'package:deskFinder/core/widgets/input_widget.dart';
import 'package:deskFinder/screens/auth/login_screen.dart';
import 'package:deskFinder/screens/offices/offices_screen.dart';
import 'package:deskFinder/utils/auth/auth.dart';
import 'package:deskFinder/utils/http/http_exceptions.dart';
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

  final TextEditingController confirmPasswordController = TextEditingController();


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
                      InputFrameWidget(
                        'Имя',
                          TextFormField(
                          controller: firstNameController,
                            validator: (value) {
                              final nameRegExp = RegExp(r"^[a-zA-Zа-яА-Я']+$");
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите своё имя';
                              } else if (!nameRegExp.hasMatch(value)) {
                                return 'Имя должно содержать только буквы';
                              } else if (value.length < 2) {
                                return 'Имя должно быть не менее 2 символов';
                              }
                              return null;
                            },
                        ),
                      ),
                      InputFrameWidget(
                        'Фамилия',
                        TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            final nameRegExp = RegExp(r"^[a-zA-Zа-яА-Я']+$");
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите свою фамилию';
                            } else if (!nameRegExp.hasMatch(value)) {
                              return 'Фамилия должна содержать только буквы';
                            } else if (value.length < 2) {
                              return 'Фамилия должна быть не менее 2 символов';
                            }
                            return null;
                          },
                        ),
                      ),

                      InputFrameWidget(
                          'Email',
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите свой email';
                            } else if (!emailRegExp.hasMatch(value)) {
                              return 'Пожалуйста, введите действительный email';
                            }
                            return null;
                          },
                        ),
                      ),

                      InputFrameWidget(
                        'Отдел',
                        TextFormField(
                          controller: departmentController,
                          maxLength: 25,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите отдел';
                            }
                            return null;
                          },
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
                      InputFrameWidget(
                        'Повторите пароль',
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, повторите пароль';
                            } else if (value.length < PASSWORD_LEN) {
                              return 'Пароль должен быть не менее $PASSWORD_LEN символов';
                            }
                            if (passwordController.text.isNotEmpty &&
                                value != passwordController.text) {
                              return 'Пароли не совпадают';
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
                                      "Ошибка при регистрации. Проверьте введённые данные и повторите снова."
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