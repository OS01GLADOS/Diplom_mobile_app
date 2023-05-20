import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/widgets/confirm_action.dart';
import 'package:deskFinder/core/widgets/loading_screen.dart';
import 'package:deskFinder/screens/floor/show_plan.dart';
import 'package:deskFinder/screens/offices/office_detail/office_detail.dart';
import 'package:deskFinder/utils/floors/floor_schema.dart';
import 'package:deskFinder/utils/floors/plan/upload_new_plan.dart';
import 'package:deskFinder/utils/retrieve_roles/is_allowed_location.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

class FloorDetailWidget extends StatefulWidget {
  final GetFloorModel floor;
  final int officeId;

  FloorDetailWidget({required this.floor, required this.officeId});

  @override
  FloorDetailState createState() => FloorDetailState();
}

class FloorDetailState extends State<FloorDetailWidget> {
  bool canUpdate = false;
  bool is_loading = false;

  @override
  void initState() {
    super.initState();

    () async {
      RetrieveRoles user = await get_user();
      setState(() {
        canUpdate = is_allowed_location(user.allowed_locations,widget.officeId);
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
                if(canUpdate)
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
                    canUpdate: canUpdate,
                  ),
                ),
                if (is_loading)
                  LoadingScreen()
              ]
            ))
    );
  }
}
