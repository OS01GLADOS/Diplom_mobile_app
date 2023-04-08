import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/utils/employees/employee_schema.dart';
import 'package:diplom_mobile_app/utils/offices/get_office_detail.dart';
import 'package:diplom_mobile_app/utils/offices/get_office_schema.dart';
import 'package:diplom_mobile_app/screens/offices/office_detail/office_stat_widget.dart';
import 'package:flutter/material.dart';

class OfficeDetailScreen extends StatefulWidget {
  final int officeId;

  OfficeDetailScreen({required this.officeId});

  @override
  _OfficeDetailScreenState createState() => _OfficeDetailScreenState();
}

class _OfficeDetailScreenState extends State<OfficeDetailScreen> {

  String address = "";
  int numberOfReservedWorkspaces = 0;
  int numberOfBookedWorkspaces = 0;
  int numberOfOccupiedWorkspaces =0;
  int numberOfFreeWorkspaces =0;
  int numberOfRemoteWorkspaces=0;



  @override
  initState() {
    super.initState();
        ()async{
          OfficeDetail office_detail = await get_office_detail(widget.officeId);
      setState(() {
        address = office_detail.address;
        numberOfReservedWorkspaces = office_detail.numberOfReservedWorkspaces;
        numberOfBookedWorkspaces = office_detail.numberOfBookedWorkspaces;
        numberOfOccupiedWorkspaces =office_detail.numberOfOccupiedWorkspaces;
        numberOfFreeWorkspaces =office_detail.numberOfFreeWorkspaces;
        numberOfRemoteWorkspaces=office_detail.numberOfRemoteWorkspaces;
        _managersList = office_detail.manager;
      });
    }();

  }

  List<Employee> _managersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text('Информация об офисе'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Адрес',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                address,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Divider(thickness: 1.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
              OfficeStatsWidget(
                  numberOfReservedWorkspaces: numberOfReservedWorkspaces,
                  numberOfBookedWorkspaces: numberOfBookedWorkspaces,
                  numberOfOccupiedWorkspaces: numberOfOccupiedWorkspaces,
                  numberOfFreeWorkspaces: numberOfFreeWorkspaces,
                  numberOfRemoteWorkspaces: numberOfRemoteWorkspaces
              ),
            ),
            Divider(thickness: 1.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Менеджеры',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Здесь будут данные о менеджерах офиса',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Divider(thickness: 1.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Этажи',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Здесь будут данные об этажах офиса',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}