import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/screens/floor/show_plan.dart';
import 'package:diplom_mobile_app/utils/floors/floor_schema.dart';
import 'package:diplom_mobile_app/utils/floors/plan/upload_new_plan.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';

class FloorDetailWidget extends StatefulWidget {
  final GetFloorModel floor;

  const FloorDetailWidget({required this.floor});

  @override
  FloorDetailState createState() => FloorDetailState();
}

class FloorDetailState extends State<FloorDetailWidget> {


  bool is_manager = false;

  @override
  void initState() {
    super.initState();

        ()async{
      RetrieveRoles user = await get_user();
      setState(() {
        is_manager = user.permissions.contains("WORKSPACE-REQUEST_APPROVE");
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.lightGreen,
          title: Text(widget.floor.toString()),
          actions: [
            if(is_manager)
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Загрузить план этажа',
              onPressed: () async {
                await sendSvgFile(widget.floor.id);
              },
            ),
          ],
        ),
        body: InteractiveViewer(
          child: Container(
            child: ShowFloorPlan(
              floorId: widget.floor.id,
            ),
          ),
          maxScale: 5.0,
          minScale: 0.1,
        ));
  }
}
