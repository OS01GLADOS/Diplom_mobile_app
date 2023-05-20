import 'package:deskFinder/core/constants/host_name.dart';
import 'package:deskFinder/utils/auth/jwt_storage.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendPatchWorkspaceRequest(String url) async {

  String? token = await get_token();

  final response = await http.patch(
    Uri.parse("$HOST_NAME$url"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    },
  );
  return response;
}


 delay_request(int request_id) async {
  final response = await sendPatchWorkspaceRequest("/api/v1/workspaces_requests/$request_id/delay-request/");

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to delay bookings');
  }
}

reject_request(int request_id) async{
  final response = await sendPatchWorkspaceRequest("/api/v1/workspaces_requests/$request_id/reject-request/");

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to reject bookings');
  }
}

approve_request(int request_id) async{
  final response = await sendPatchWorkspaceRequest("/api/v1/workspaces_requests/$request_id/approve-request/");

  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to approve bookings');
  }
}
