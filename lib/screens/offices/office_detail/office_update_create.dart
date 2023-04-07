import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/input_frame.dart';
import 'package:diplom_mobile_app/utils/employees/employee_schema.dart';
import 'package:diplom_mobile_app/utils/employees/employees.dart';
import 'package:diplom_mobile_app/utils/locations/locations.dart';
import 'package:diplom_mobile_app/utils/locations/locations_schema.dart';
import 'package:diplom_mobile_app/utils/offices/get_office.dart';
import 'package:diplom_mobile_app/utils/offices/get_office_schema.dart';
import 'package:diplom_mobile_app/utils/offices/offices.dart';
import 'package:flutter/material.dart';


class OfficeUpdateCreate extends StatefulWidget {

  OfficeUpdateCreate({Key? key, this.office_id}) : super(key: key);
  final int? office_id;


  @override
  State<StatefulWidget> createState() {
    return _OfficeUpdateCreateState();
  }
}

class _OfficeUpdateCreateState extends State<OfficeUpdateCreate> {

  bool is_update = false;

  String title = 'Добавить офис';
  String button_text = "Добавить";

  @override
  void initState() {
    super.initState();
        ()async{

          var locations = await get_all_locations();
          var employees = await get_all_employees();
          setState(() {
            _locations = locations;
            _owners = employees;
            is_update = true;
          });
          if (widget.office_id != null){
            Office office = await get_office(widget.office_id!);
            setState(() {
              title = "Изменить офис";
              button_text = "Сохранить изменения";
              _addressController.text = office.address;
              _postcodeController.text = office.postcode;
              _selectedLocationId = office.location;
              _selectedOwnerId = office.owner;
            });
          }
    }();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  int? _selectedLocationId;
  int? _selectedOwnerId;
  // Список мест для выбора

  List<LocationsSchema> _locations = [];
  List<Employee> _owners = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text(title),
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
                InputFrameWidget(
                  'Адрес',
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите адрес';
                      }
                      return null;
                    },
                    controller: _addressController,
                  ),
                ),
                InputFrameWidget(
                  'Индекс',
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите индекс';
                      }
                      return null;
                    },
                    controller: _postcodeController,
                  ),
                ),
                InputFrameWidget(
              'Владелец офиса',
                  DropdownButtonFormField<int>(
                    value: _selectedOwnerId,
                    items: _owners.map((owner) {
                      return DropdownMenuItem<int>(
                        value: owner.id,
                        child: Text(owner.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOwnerId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите владельца офиса';
                      }
                      return null;
                    },
                  ),
            ),

                InputFrameWidget(
                  'Местоположение',
                  DropdownButtonFormField<int>(
                    value: _selectedLocationId,
                    items: _locations.map((location) {
                      return DropdownMenuItem<int>(
                        value: location.id,
                        child: Text(location.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocationId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Выберите местоположение';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorConstants.lightGreen,
                  ),
                  onPressed: () async {
                    print('button pressed');
                    if (_formKey.currentState!.validate()) {
                      await officeAction(
                        _addressController.text,
                        _postcodeController.text,
                        _selectedOwnerId!,
                        _selectedLocationId!,
                          (widget.office_id != null),
                          (widget.office_id == null) ? 0 : widget.office_id!
                      );
                      Navigator.of(context).pop(true);

                    }
                  },
                  child: Text(button_text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
