import 'package:diplom_mobile_app/core/constants/workspace_size.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/get_workspace_color.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';

class WorkspaceContainer extends StatefulWidget {
  final Workspace workspace;

  const WorkspaceContainer({Key? key, required this.workspace})
      : super(key: key);

  @override
  _WorkspaceContainerState createState() => _WorkspaceContainerState();
}

class _WorkspaceContainerState extends State<WorkspaceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: WORKSPACE_WIDTH,
      height: WORKSPACE_HEIGHT,
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
    );
  }
}