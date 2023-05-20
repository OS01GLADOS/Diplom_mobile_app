import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/widgets/loading_screen.dart';
import 'package:deskFinder/screens/floor/office_floor_list.dart';
import 'package:deskFinder/screens/offices/office_detail/office_stat_widget.dart';
import 'package:deskFinder/screens/offices/offices_screen.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:deskFinder/utils/employees/employee_schema.dart';
import 'package:deskFinder/utils/offices/get_office_detail.dart';
import 'package:deskFinder/utils/offices/get_office_schema.dart';
import 'package:flutter/material.dart';


class OfficeDetailScreen extends StatefulWidget {
  final int officeId;

  OfficeDetailScreen({required this.officeId});

  @override
  _OfficeDetailScreenState createState() => _OfficeDetailScreenState();
}

class _OfficeDetailScreenState extends State<OfficeDetailScreen>  {
  bool is_loading = false;

  String address = "";
  int numberOfReservedWorkspaces = 0;
  int numberOfBookedWorkspaces = 0;
  int numberOfOccupiedWorkspaces = 0;
  int numberOfFreeWorkspaces = 0;
  int numberOfRemoteWorkspaces = 0;

  @override
  initState() {
    super.initState();
    print('start detail state');
    is_loading = true;
    () async {
      OfficeDetail office_detail = await get_office_detail(widget.officeId);
      setState(() {
        address = office_detail.address;
        numberOfReservedWorkspaces = office_detail.numberOfReservedWorkspaces;
        numberOfBookedWorkspaces = office_detail.numberOfBookedWorkspaces;
        numberOfOccupiedWorkspaces = office_detail.numberOfOccupiedWorkspaces;
        numberOfFreeWorkspaces = office_detail.numberOfFreeWorkspaces;
        numberOfRemoteWorkspaces = office_detail.numberOfRemoteWorkspaces;
        _managersList = office_detail.manager;
        _owner = office_detail.owner;
      });
      is_loading = false;
      print('end detail state');
    }();

  }


  
  Employee? _owner;
  List<Employee> _managersList = [];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OfficesScreen.without_screen_title(
              ),
            ),
          );
          return Future.value(false);
        },
      child:  Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.lightGreen,
            title: Text('Информация об офисе'),
          ),
          body:
          Stack(
            children: [
              if(!is_loading)
                SingleChildScrollView(
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
                        child: OfficeStatsWidget(
                            numberOfReservedWorkspaces: numberOfReservedWorkspaces,
                            numberOfBookedWorkspaces: numberOfBookedWorkspaces,
                            numberOfOccupiedWorkspaces: numberOfOccupiedWorkspaces,
                            numberOfFreeWorkspaces: numberOfFreeWorkspaces,
                            numberOfRemoteWorkspaces: numberOfRemoteWorkspaces),
                      ),
                      Divider(thickness: 1.0),
                      if(_managersList.isNotEmpty || _owner != null)
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
                      if(_managersList.isNotEmpty || _owner != null)
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_owner != null)
                                  Text("${_owner.toString()}, Владелец офиса"),
                                for (final manager in _managersList)
                                  Text("${manager.toString()}, офис менеджер")
                              ],
                            )
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
                        child: FloorsListWidget(office_id: widget.officeId, ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              if(is_loading)
                LoadingScreen(),
            ],
          )


      ),
    );
  }
}
