import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/confirm_action.dart';
import 'package:diplom_mobile_app/core/widgets/loading_screen.dart';
import 'package:diplom_mobile_app/screens/floor/show_plan.dart';
import 'package:diplom_mobile_app/screens/offices/office_detail/office_detail.dart';
import 'package:diplom_mobile_app/utils/floors/floor_schema.dart';
import 'package:diplom_mobile_app/utils/floors/plan/upload_new_plan.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

class FloorDetailWidget extends StatefulWidget {
  final GetFloorModel floor;
  final int officeId;

  FloorDetailWidget({required this.floor, required this.officeId});

  @override
  FloorDetailState createState() => FloorDetailState();
}

class FloorDetailState extends State<FloorDetailWidget> {
  bool is_manager = false;
  bool is_loading = false;

  @override
  void initState() {
    super.initState();

    () async {
      RetrieveRoles user = await get_user();
      setState(() {
        is_manager = user.permissions.contains("WORKSPACE-REQUEST_APPROVE");
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('action on pop');
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OfficeDetailScreen(
                officeId: widget.officeId,
              ),
            ),
          );
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorConstants.lightGreen,
              title: Text(widget.floor.toString()),
              actions: [
                if (is_manager)
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: 'Загрузить план этажа',
                    onPressed: () async {
                      bool confirm = await confirmAction(context,
                          "Вы уверены, что хотите загрузить новый план? Вся ТЕКУЩАЯ рассадка этажа удалится");
                      if (confirm) {
                        setState(() {
                          is_loading = true;
                        });
                        var res = await sendSvgFile(widget.floor.id);
                        if (res == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('План успешно загружен'),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FloorDetailWidget(
                                floor: widget.floor,
                                officeId: widget.officeId,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
              ],
            ),
            body:

            Stack(
              children:[
                if (!is_loading)
                Container(
                  child: ShowFloorPlan(
                    floorId: widget.floor.id,
                  ),
                ),
                if (is_loading)
                  LoadingScreen()
              ]
            ))
    );
  }
}
