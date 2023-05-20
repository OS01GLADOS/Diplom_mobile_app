bool is_admin(List permissions) {
  List<String> admin_permissions = [
    'LOCATION_CREATE', 'LOCATION_UPDATE', 'LOCATION_DELETE', 'OFFICE_CREATE', 'OFFICE_UPDATE', 'OFFICE_DELETE'
  ];

  return admin_permissions.every((permission) => permissions.contains(permission));
}