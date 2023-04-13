import 'package:diplom_mobile_app/core/constants/host_name.dart';
import 'package:diplom_mobile_app/utils/floors/plan/retrieve_plan.dart';
import 'package:diplom_mobile_app/utils/floors/plan/rooms_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/auth/jwt_storage.dart';

class ShowFloorPlan extends StatefulWidget {
  final int floorId;

  const ShowFloorPlan({Key? key, required this.floorId});

  @override
  _ShowFloorPlanState createState() => _ShowFloorPlanState();
}

class _ShowFloorPlanState extends State<ShowFloorPlan> {
  late Future<List<Room>> _future;
  List<Room> _rooms = [];
  late final WebSocketChannel _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _future = get_floor_rooms(widget.floorId).then((value) => _rooms = value);
    get_token().then((token) {
    var url = '$WEBSOCKET_URL/ws/floor/${widget.floorId}?token=$token';
      _webSocketChannel = IOWebSocketChannel.connect(url);

      // Слушаем веб-сокет и выводим сообщения в консоль
      _webSocketChannel.stream.listen((event) {
        print('WebSocket message received: $event');
      });
      // Создаем экземпляр WebSocketChannel и подключаемся к веб-сокету
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
    return FutureBuilder<List<Room>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // устанавливаем направление горизонтального скролла
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                constraints: BoxConstraints(maxWidth: 10000, maxHeight: 10000),
                child: Stack(
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
                          child: Stack(
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
                          )),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
      },
    );
  }
}
