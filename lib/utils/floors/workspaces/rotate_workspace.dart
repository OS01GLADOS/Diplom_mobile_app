import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

rotate_workspace(int rotation, Workspace workspace, WebSocketChannel ws_channel){
  var final_rotation =(workspace.rotateDegree + rotation);

  if (final_rotation < -90){
    final_rotation = final_rotation + 180;
  }
  if (final_rotation > 90){
    final_rotation = final_rotation - 180;
  }

  var message = '''
  {
    "event": "patch",
    "workspace": {
        "id": ${workspace.id},
            "number": ${workspace.number},
            "status": "${workspace.status}",
            "occupation_type": null,
            "room": ${workspace.room},
            "employee": ${workspace.employee},
            "coordinates": ${workspace.coordinates},
            "rotate_degree": ${final_rotation}
    }
}
  ''';

  ws_channel.sink.add(message);
}