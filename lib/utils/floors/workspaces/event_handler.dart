import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

List<Workspace> parseWorkspaces(List<dynamic> workspaceList) {
  return workspaceList.map((json) => Workspace.fromJson(json)).toList();
}


change_workspace_position(Workspace workspace, WebSocketChannel ws_channel, double left, double top){
  var message = '{'
      '"event":"patch_drag_n_drop",'
      '"workspace":{'
      '"id":${workspace.id},'
      '"status": "${workspace.status}",'
      '"coordinates": [[$left,$top]],'
      '"room": ${workspace.room}}}';
  ws_channel.sink.add(message);
}

edit_workspace(Workspace workspace, WebSocketChannel ws_channel, String status, int? employee){
  var message = '''
  {
    "event": "patch",
    "workspace": {
        "id": ${workspace.id},
            "number": ${workspace.number},
            "status": "$status",
            "occupation_type": null,
            "room": ${workspace.room},
            "employee": $employee,
            "coordinates": ${workspace.coordinates}
    }
}
  ''';

  ws_channel.sink.add(message);
}