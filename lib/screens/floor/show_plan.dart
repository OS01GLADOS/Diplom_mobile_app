import 'dart:convert';
import 'dart:math';

import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/screens/bookings/create_workspace_request.dart';
import 'package:deskFinder/screens/floor/custom_stack.dart';
import 'package:deskFinder/screens/floor/workspace.dart';
import 'package:deskFinder/screens/floor/workspace_info_bar.dart';
import 'package:deskFinder/utils/floors/plan/retrieve_plan.dart';
import 'package:deskFinder/utils/floors/plan/rooms_schema.dart';
import 'package:deskFinder/utils/floors/workspaces/check_overlap.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';
import 'package:deskFinder/utils/retrieve_roles/user_storage.dart';
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
  final bool canUpdate;

  ShowFloorPlan({Key? key, required this.floorId, required this.canUpdate}): super(key: key);

  @override
  ShowFloorPlanState createState() => ShowFloorPlanState();
}

class ShowFloorPlanState extends State<ShowFloorPlan> {

  bool isPlanLoaded = false;

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

   void reload_objects(){
     _webSocketChannel.sink.add('''{
          "event":"list"
          }''');
     _future = get_floor_rooms(widget.floorId).then((value) => _rooms = value);


   }

  @override
  void initState() {
    super.initState();

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
                    // !!! show lists of all fooms on the plan
                    FutureBuilder<List<Room>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Room>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          if(snapshot.data!.isEmpty){
                            print(snapshot.data);
                            print(snapshot.data!.isEmpty);
                            return
                            Padding(padding: EdgeInsets.only(top: 40, left: 20),child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'План этажа не загружен',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if(widget.canUpdate)
                            Text(
                              'Нажмите на кнопку справа вверху\nдля загрузки плана',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              )
                            )
                              ],
                            ));
                          }
                          else{
                            isPlanLoaded = true;
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
                          }

                        } else {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                      },
                    ),
                    // !!! show workspaces on the plan
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
                                      CustomStack(
                                        children:[
                                          Transform.rotate(
                                            angle: workspace.rotateDegree * pi / 180,
                                            alignment: Alignment.topCenter,
                                            child: Draggable(
                                              data: workspace,
                                              child:
                                              InkWell(
                                                onLongPress: () {
                                                  if(!widget.canUpdate && (workspace.status == "Booked"||workspace.status == "Free"))
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
                                                          if (widget.canUpdate)
                                                          //изменить место
                                                          ListTile(
                                                            leading: Icon(Icons.edit),
                                                            title: Text('Изменить место'),
                                                            onTap: () async {
                                                              Navigator.of(context).pushReplacement(
                                                                  MaterialPageRoute(builder: (context) => EditWorkspaceScreen(workspace: workspace, webSocketChannel: _webSocketChannel,)));
                                                            },
                                                          ),
                                                          if (widget.canUpdate)
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
                                                          if (!widget.canUpdate)
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
                                                if (!widget.canUpdate){
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text('У вас нед разрешений на это действие'),
                                                  ));
                                                  return;
                                                }
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
                                        background:WorkspaceInfoBar(workspace:workspace, webSocketChannel: _webSocketChannel, canUpdate: widget.canUpdate,),
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
          //!!! button that adds workspace
          if (widget.canUpdate)
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
