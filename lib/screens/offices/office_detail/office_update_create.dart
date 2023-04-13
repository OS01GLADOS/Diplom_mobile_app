import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/button_style.dart';
import 'package:diplom_mobile_app/core/widgets/input_frame.dart';
import 'package:diplom_mobile_app/utils/employees/employee_schema.dart';
import 'package:diplom_mobile_app/utils/employees/employees.dart';
import 'package:diplom_mobile_app/utils/floors/get_office_floors.dart';
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
  List<int> _floor_list = [1];
  List<TextEditingController> _floor_controllers = [];

  void removeFloor(int index) {
    setState(() {
      _floor_list.removeAt(index);
      _floor_controllers.removeAt(index);
      // обновить значения контроллеров
      for (int i = 0; i < _floor_controllers.length; i++) {
        _floor_controllers[i].text = _floor_list[i].toString();
      }
    });
  }

  void addFloor() {
    setState(() {
      int lastFloor = _floor_list.last;
      _floor_list.add(lastFloor + 1);
      _floor_controllers.add(TextEditingController(text: (lastFloor + 1).toString()));
    });
  }

  String title = 'Добавить офис';
  String button_text = "Добавить";
  List<int> _managers =[];



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
            var floors = await get_office_floors(widget.office_id!);
            var floor_list = floors.map((e) => e.number).toList();

            Office office = await get_office(widget.office_id!);

            setState(() {
              _floor_list = floor_list;
              title = "Изменить офис";
              button_text = "Сохранить изменения";
              _addressController.text = office.address;
              _postcodeController.text = office.postcode;
              _selectedLocationId = office.location;
              _selectedOwnerId = office.owner;
              _managers = office.manager;
            });
          }

          for (int i = 0; i < _floor_list.length; i++) {
            _floor_controllers.add(TextEditingController(text: _floor_list[i].toString()));
          }
    }();
  }

  @override
  void dispose() {
    // освободить контроллеры при удалении виджета
    for (int i = 0; i < _floor_controllers.length; i++) {
      _floor_controllers[i].dispose();
    }
    super.dispose();
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  int? _selectedLocationId;
  int? _selectedOwnerId;

  int? _selectedManager1Id;
  int? _selectedManager2Id;
  int? _selectedManager3Id;
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
                  'Менеджеры',
                  Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: _selectedManager1Id,
                        items: [
                          ..._owners.map((owner) {
                            return DropdownMenuItem<int>(
                              value: owner.id,
                              child: Text(owner.toString()),
                            );
                          }),
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('---'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedManager1Id = value;
                          });
                        },
                        validator: null,
                      ),
                      DropdownButtonFormField<int>(
                        value: _selectedManager2Id,
                        items: [
                          ..._owners.map((owner) {
                            return DropdownMenuItem<int>(
                              value: owner.id,
                              child: Text(owner.toString()),
                            );
                          }),
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('---'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedManager2Id = value;
                          });
                        },
                        validator: null,
                      ),
                      DropdownButtonFormField<int>(
                        value: _selectedManager3Id,
                        items: [
                          ..._owners.map((owner) {
                            return DropdownMenuItem<int>(
                              value: owner.id,
                              child: Text(owner.toString()),
                            );
                          }),
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('---'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedManager3Id = value;
                          });
                        },
                        validator: null,
                      ),
                    ],
                  ),
                ),

                InputFrameWidget(
                  'этажи',
                    Padding
                      (
                      padding: EdgeInsets.only(top: 14),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _floor_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    removeFloor(index);

                                  },
                                ),
                                title: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _floor_controllers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _floor_list[index] = int.parse(value);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            style: default_style,
                            child: Text('Добавить этаж'),
                            onPressed: addFloor,
                          ),
                        ],
                      )
                    )


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
                    if (_formKey.currentState!.validate()) {
                      //get office floors

                      await officeAction(
                        [_selectedManager1Id, _selectedManager2Id, _selectedManager3Id],
                        _addressController.text,
                        _postcodeController.text,
                        _selectedOwnerId!,
                        _selectedLocationId!,
                        _floor_list,
                          (widget.office_id != null),
                          (widget.office_id == null) ? 0 : widget.office_id!,
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
