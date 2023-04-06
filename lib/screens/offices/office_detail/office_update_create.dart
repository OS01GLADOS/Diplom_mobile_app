import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class OfficeUpdateCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfficeUpdateCreateState();
  }
}

class _OfficeUpdateCreateState extends State<OfficeUpdateCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _jiraOfficeIdController = TextEditingController();
  final TextEditingController _floorsNumbersController =
      TextEditingController();
  final TextEditingController _managerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text('Create New Office'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputWidget(
                    'Адрес',
                    _addressController,
                    'text',
                  ),
                  InputWidget(
                    'Индекс',
                    _postcodeController,
                    'text',
                  ),
                  InputWidget(
                    'Jira Id',
                    _jiraOfficeIdController,
                    'number',
                  ),
                  InputWidget(
                    'Floors Numbers',
                    _floorsNumbersController,
                    'text',
                  ),
                  InputWidget(
                    'Manager',
                    _managerController,
                    'text',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement create office functionality
                      }
                    },
                    child: Text('Добавить'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
