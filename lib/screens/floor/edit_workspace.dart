import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/button_style.dart';
import 'package:diplom_mobile_app/core/widgets/input_frame.dart';
import 'package:diplom_mobile_app/utils/employees/employee_schema.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/event_handler.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/employees/employees.dart';

class EditWorkspaceScreen extends StatefulWidget {
  final Workspace workspace;
  final WebSocketChannel webSocketChannel;

  const EditWorkspaceScreen({required this.workspace, required this.webSocketChannel});

  @override
  _EditWorkspaceScreenState createState() => _EditWorkspaceScreenState();
}

class _EditWorkspaceScreenState extends State<EditWorkspaceScreen> {
  int? _selectedEmployeeId;
  List<Employee> _employees = [];

  List<Map<String, dynamic>> statusList = [
    {'id': 0, 'status': 'Free', 'status_rus': 'свободно'},
    {'id': 1, 'status': 'Reserved', 'status_rus': 'зарезервировано'},
    {'id': 2, 'status': 'Booked', 'status_rus': 'забронировано'},
    {'id': 3, 'status': 'Occupied', 'status_rus': 'занято'},
    {'id': 4, 'status': 'Remote', 'status_rus': 'виртуальное'},
  ];

  int getStatusId(String statusName) {
    for (int i = 0; i < statusList.length; i++) {
      if (statusList[i]['status'] == statusName) {
        return statusList[i]['id'];
      }
    }
    return 0;
  }

  String _selectedStatus = "";

  @override
  void initState() {
    super.initState();
    _selectedStatus =
        statusList[getStatusId(widget.workspace.status)]['status'];
    () async {
      var employees = await get_all_employees();
      setState(() {
        _employees = employees;
        _selectedEmployeeId = widget.workspace.employee;
      });
    }();
    //_selectedStatus = widget.workspace.status;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.lightGreen,
          title: Text("Изменить рабочее место"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (widget.workspace.status != 'Remote')
                      InputFrameWidget(
                          'Статус места',
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            items: statusList.map((status) {
                              return DropdownMenuItem<String>(
                                value: status['status'],
                                child: Text(status['status_rus']),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedStatus = newValue!;
                              });
                            },
                          )),
                    InputFrameWidget(
                      'Сотрудник',
                      DropdownButtonFormField<int>(
                        value: _selectedEmployeeId,
                        items: _employees.map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee.id,
                            child: Text(employee.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEmployeeId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null && _selectedStatus == 'Occupied') {
                            return 'Выберите сотрудника';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: default_style,
                        child: Text("Сохранить изменения"),
                        onPressed: () async {
                          print('button pressed');
                          if (_formKey.currentState!.validate()) {}

                          edit_workspace(
                            widget.workspace,
                            widget.webSocketChannel,
                              _selectedStatus,
                              _selectedEmployeeId
                          );


                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                            content: Text('Место успешно изменено'),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
