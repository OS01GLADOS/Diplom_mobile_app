import 'package:deskFinder/utils/floors/workspaces/rotate_workspace.dart';
import 'package:deskFinder/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WorkspaceInfoBar extends StatefulWidget {
  final bool canUpdate;

  final Workspace workspace;
  final WebSocketChannel webSocketChannel;

  const WorkspaceInfoBar(
      {Key? key,
        required this.workspace,
        required this.webSocketChannel,
        required this.canUpdate
      })
      : super(key: key);

  @override
  _WorkspaceInfoBarState createState() => _WorkspaceInfoBarState();
}

class _WorkspaceInfoBarState extends State<WorkspaceInfoBar> {

  String format_date(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  rotateWorkspace(int deltaDegree){
    print(deltaDegree);
    rotate_workspace(
        deltaDegree,
      widget.workspace,
      widget.webSocketChannel
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
        ),
        alignment: Alignment.center,
        child:
        Column(
          children: [
            if(widget.canUpdate)
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.rotate_left),
                  onPressed: () {
                    print('lefty');
                    rotateWorkspace(-15);
                    // Обработчик нажатия на кнопку поворота
                  },
                ),
                IconButton(
                  icon: Icon(Icons.rotate_right),
                  onPressed: () {
                    print('righty');
                    rotateWorkspace(15);
                    // Обработчик нажатия на кнопку поворота
                  },
                ),
              ],
            ),

            Text('Статус: ${widget.workspace.translateWorkspaceStatus()}'),
            if(widget.workspace.employee != null)
              Text("Сотрудник"),
            if(widget.workspace.employee != null)
              Text('${widget.workspace.employeeName}'),
            if(widget.workspace.activeRequests!.isNotEmpty)
              Text('На рассмотрении:'),
            if(widget.workspace.activeRequests!.isNotEmpty)
              Column(
                children: [
                  for (final request in widget.workspace.activeRequests!)
                    Column(
                      children: [
                        Text(
                          request.preferredName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '${format_date(request.startDate)}-${format_date(request.endDate)}'
                        )
                      ],
                    )

                ],
              ),
            if(widget.workspace.bookedStatus!.isNotEmpty)
              Text('Одобрено:'),
            if(widget.workspace.bookedStatus!.isNotEmpty)
              Column(
                children: [
                  for (final request in widget.workspace.bookedStatus!)
                    Column(
                      children: [
                        Text(
                          request.preferredName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '${format_date(request.startDate)}-${format_date(request.endDate)}'
                        )
                      ],
                    )

                ],
              ),
          ],
        )
    );
  }
}