import 'dart:convert';
import 'dart:math';

import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/screens/bookings/create_workspace_request.dart';
import 'package:diplom_mobile_app/screens/floor/workspace.dart';
import 'package:diplom_mobile_app/utils/floors/plan/retrieve_plan.dart';
import 'package:diplom_mobile_app/utils/floors/plan/rooms_schema.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/check_overlap.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:diplom_mobile_app/utils/retrieve_roles/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/widgets/confirm_action.dart';
import '../../utils/auth/jwt_storage.dart';
import '../../utils/floors/workspaces/event_handler.dart';
import '../../utils/floors/workspaces/workspace_schema.dart';
import 'edit_workspace.dart';

class ShowFloorPlan extends StatefulWidget {
  final int floorId;



  ShowFloorPlan({Key? key, required this.floorId});

  @override
  _ShowFloorPlanState createState() => _ShowFloorPlanState();
}

class _ShowFloorPlanState extends State<ShowFloorPlan> {

  bool is_manager = false;

  late Future<List<Room>> _future;
  List<Room> _rooms = [];
  

  Future<List<Workspace>> get_workspaces() async {
    return _workspaces;
  }

  _setWorkspaces(workspaces) {
    setState(() {
      _workspaces = workspaces;
    });
  }

  List<Workspace> _workspaces = [];
  int room_id =0;

  late final WebSocketChannel _webSocketChannel;

  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    ()async{
      RetrieveRoles user = await get_user();
      setState(() {
        is_manager = user.permissions.contains("WORKSPACE-REQUEST_APPROVE");
      });
    }();

    _future = get_floor_rooms(widget.floorId).then((value) => _rooms = value);
    get_token().then((token) {
      var url = '$WEBSOCKET_URL/ws/floor/${widget.floorId}?token=$token';
      _webSocketChannel = IOWebSocketChannel.connect(url);

      _webSocketChannel.stream.listen((event) {
        print('WebSocket message received: $event');

        final eventData = jsonDecode(event);
        if (eventData['event'] == 'list_workspace') {
          final workspaces = eventData['workspaces'];
          var ws_list = parseWorkspaces(workspaces);
          _setWorkspaces(ws_list);
        }
        if (eventData['event'] == 'change_workspace_drag_n_drop') {
          print("[event] change_workspace_drag_n_drop");
          _webSocketChannel.sink.add('''{
          "event":"list"
          }''');
        }
        if (eventData['event'] == 'create_workspace') {
          print("[event] create_workspace");
          _webSocketChannel.sink.add('''{
          "event":"list"
          }''');
        }
        if (eventData['event'] == 'delete_workspace') {
          print("[event] delete_workspace");
          _webSocketChannel.sink.add('''{
          "event":"list"
          }''');
        }
        if (eventData['event'] == 'change_workspace') {
          print("[event] change_workspace");
          _webSocketChannel.sink.add('''{
          "event":"list"
          }''');
        }
      });
    });
  }

  @override
  void dispose() {
    // Закрываем соединение при уничтожении виджета
    _webSocketChannel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return
      Stack(
        children: [
        SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // устанавливаем направление горизонтального скролла
            child: Container(
                constraints: BoxConstraints(maxWidth: 10000, maxHeight: 10000),
                child: Stack(
                  children: [
                    FutureBuilder<List<Room>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Room>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          return Stack(
                            fit: StackFit.loose,
                            children: _rooms.map((room) {
                              return Positioned(
                                left: room.containerCoordinates[0][0],
                                top: room.containerCoordinates[0][1],
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(room.number),
                                        ),
                                      );
                                    },
                                    child:
                                    DragTarget<Workspace>(
                                      builder: (BuildContext context, List<Workspace?> candidateData, List<dynamic> rejectedData){
                                        return Stack(
                                          fit: StackFit.loose,
                                          children: [
                                            SvgPicture.network(room.layout),
                                            Positioned.fill(
                                              child: Center(
                                                child: Text(
                                                  room.number,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      onAccept: (Workspace? data) {
                                        room_id = room.id;
                                      },
                                    )
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                      },
                    ),
                    FutureBuilder<List<Workspace>>(
                      future: get_workspaces(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Workspace>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final workspaces = snapshot.data!;
                          // Обрабатываем список рабочих мест
                          return Stack(
                            key: _key,
                            children: workspaces
                                .asMap()
                                .map((index, workspace) {
                              return MapEntry(
                                index,
                                Positioned(
                                  left: workspace.coordinates[0][0],
                                  top: workspace.coordinates[0][1],
                                  child:
                                  Stack(
                                    children: [
                                      Transform.rotate(
                                      angle: workspace.rotateDegree * pi / 180,
                                      alignment: Alignment.topCenter,
                                      child: Draggable(
                                        data: workspace,
                                        child:
                                        InkWell(
                                          onLongPress: () {
                                            // показываем меню при долгом нажатии на элемент
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children:
                                                  [
                                                    Container(
                                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Text(
                                                        'Место №${workspace.number}',
                                                        style: TextStyle(
                                                          fontSize: 18.0, // задаем размер шрифта
                                                        ),
                                                        textAlign: TextAlign.center, // центрируем текст
                                                      ),
                                                    ),
                                                    //if (is_manager)
                                                    //изменить место
                                                    ListTile(
                                                      leading: Icon(Icons.edit),
                                                      title: Text('Изменить место'),
                                                      onTap: () async {
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(builder: (context) => EditWorkspaceScreen(workspace: workspace, webSocketChannel: _webSocketChannel,)));
                                                      },
                                                    ),
                                                    //if (is_manager)
                                                    //удалить место
                                                    ListTile(
                                                      leading: Icon(Icons.clear),
                                                      title: Text('Удалить рабочее место'),
                                                      onTap: () async {
                                                        try {
                                                          bool confirm = await confirmAction(context, "Вы уверены, что хотите отменить запрос?");
                                                          if (confirm) {
                                                            _webSocketChannel.sink.add(
                                                                '''
                                                            {
                                                                "event":"delete",
                                                                "id": ${workspace.id}
                                                            }
                                                            '''
                                                            );
                                                          }
                                                        }  finally {
                                                          Navigator.of(context).pop();
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                    //if (!is_manager)
                                                    //забронировать место
                                                    ListTile(
                                                        leading: Icon(Icons.add),
                                                        title: Text('Забронировать место'),
                                                        onTap: () async {
                                                          Navigator.of(context).pushReplacement(
                                                              MaterialPageRoute(builder: (context) => BookingCreateWidget(workspace)));
                                                        }
                                                    ),

                                                  ]
                                                  ,
                                                );
                                              },
                                            );
                                          },
                                          child: WorkspaceContainer(workspace:workspace),
                                        ),
                                        feedback: Transform.rotate(
                                          angle: workspace.rotateDegree * pi / 180,
                                          alignment: Alignment.topCenter,
                                          child: WorkspaceContainer(workspace:workspace),),
                                        childWhenDragging: Container(),
                                        onDragEnd: (details) {
                                          if (details.wasAccepted){
                                            final RenderBox? box =
                                            _key.currentContext?.findRenderObject() as RenderBox?;
                                            final Offset? position = box?.localToGlobal(Offset.zero);
                                            double x = 0, y =0;
                                            if (position != null) {
                                              x = (details.offset.dx - position.dx);
                                              y = (details.offset.dy - position.dy);
                                            }
                                            if (checkOverlap(workspace.id, x,y, _workspaces, workspace.rotateDegree))
                                            {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Внимание, столы пересекаются'),
                                              ));
                                            }
                                            else{
                                              workspace.room = room_id;
                                              //x  00
                                              workspace.coordinates[0][0] = x;
                                              //y  01
                                              workspace.coordinates[0][1] = y;
                                              change_workspace_position(workspace, _webSocketChannel, x, y);
                                              setState((){});
                                            }
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Внимание, стол не может находиться за границами кабинета'),
                                            ));
                                          }

                                        },
                                        onDraggableCanceled:
                                            (Velocity velocity, Offset offset) {
                                          setState(() {
                                            // обработка отмены перетаскивания
                                          });
                                        },
                                      ),
                                    ),
                                    ],
                                  )

                                ),
                              );
                            })
                                .values
                                .toList(),
                          );
                        }
                      },
                    )
                  ],
                ))),
      ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              backgroundColor: ColorConstants.lightGreen,
              onPressed: () {
                print(_rooms[0].id);
                _webSocketChannel.sink.add(
                    '''{
                        "event": "create",
                        "workspace":{
                             "room":${_rooms[0].id},
                        "status": "Free",
                            "coordinates" :[
                                [0, 0]
                            ]
                        }
                    }'''
                );
                // handle button press
              },
              tooltip: 'Добавить рабочее место',
              child: Icon(Icons.add),

            ),
          ),
          ]
      );



  }
}
