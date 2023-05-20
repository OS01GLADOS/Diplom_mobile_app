bool is_manager(List permissions) {
  List<String> manager_permissions = [
    'FLOOR_CREATE-PLAN', 'FLOOR_RETRIEVE-PLAN', 'FLOOR_ROOM-AFFILIATION', 'ROOM_UPDATE',
    'WORKSPACE_CREATE', 'WORKSPACE_UPDATE', 'WORKSPACE_DELETE', 'WORKSPACE_ASSIGN',
    'WORKSPACE_DETACH', 'WORKSPACE-REQUEST_APPROVE', 'WORKSPACE-REQUEST_REJECT', 'FLOOR_UPDATE'
  ];

  return manager_permissions.every((permission) => permissions.contains(permission));
}