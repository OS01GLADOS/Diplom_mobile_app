import 'package:diplom_mobile_app/utils/floors/workspaces/get_workspace_color.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WorkspaceContainer extends StatefulWidget {
  final Workspace workspace;

  const WorkspaceContainer({Key? key, required this.workspace})
      : super(key: key);

  @override
  _WorkspaceContainerState createState() => _WorkspaceContainerState();
}

class _WorkspaceContainerState extends State<WorkspaceContainer> {
  bool _showLabel = false;

  String format_date(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showLabel = !_showLabel;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: getWorkspaceColor(widget.workspace.status),
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.workspace.number}',
              style: TextStyle(
                fontSize: 14.0, // задаем размер шрифта
              ),
            ),
          ),
          if (_showLabel)
            Container(

              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
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
            ),
        ],
      ),
    );
  }
}