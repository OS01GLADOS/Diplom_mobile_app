import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/input_widget.dart';
import 'package:diplom_mobile_app/utils/http/http_exceptions.dart';
import 'package:diplom_mobile_app/utils/locations/locations.dart';
import 'package:flutter/material.dart';

class CreateLocationWidget extends StatefulWidget {
  const CreateLocationWidget({Key? key}) : super(key: key);

  @override
  _CreateLocationWidgetState createState() => _CreateLocationWidgetState();
}

class _CreateLocationWidgetState extends State<CreateLocationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text('Добавить локацию'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputWidget(
                'Буквенный Код Страны',
                _countryController,
                'text',
              ),
              InputWidget(
                'Город',
                _cityController,
                'text',
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String country = _countryController.text;
                    final String city = _cityController.text;
                    try {
                      await createLocation(country, city);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Локация успешно добавлена'),
                        duration: Duration(seconds: 5),
                      ));
                      Navigator.of(context).pop(true);
                    } on BadRequestException catch (e) {
                      // Обрабатываем ошибку BadRequestException и выводим сообщение пользователю
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Ошибка: ${e.toString()}'),
                        duration: Duration(seconds: 5),
                      ));
                    } catch (e) {
                      // Обрабатываем все остальные ошибки и выводим сообщение пользователю
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Ошибка: $e'),
                        duration: Duration(seconds: 5),
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: ColorConstants.lightGreen,
                ),
                child: Text('Создать локацию'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}