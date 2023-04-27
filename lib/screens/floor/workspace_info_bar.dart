import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';

class WorkspaceInfoBar extends StatefulWidget {
  final Workspace workspace;

  const WorkspaceInfoBar({Key? key, required this.workspace})
      : super(key: key);

  @override
  _WorkspaceInfoBarState createState() => _WorkspaceInfoBarState();
}

class _WorkspaceInfoBarState extends State<WorkspaceInfoBar> {
  bool _showLabel = false;

  String format_date(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
        onTap: () {
      setState(() {
        _showLabel = !_showLabel;
      });
    },
    child:
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
    );
  }
}