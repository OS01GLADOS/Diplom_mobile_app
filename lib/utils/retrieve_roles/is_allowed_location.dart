import 'package:deskFinder/utils/retrieve_roles/is_admin.dart';
import 'package:deskFinder/utils/retrieve_roles/retrieve_roles_schema.dart';

bool is_allowed_location(RetrieveRoles user, int number) {
  if (is_admin(user.permissions))
    return true;
  if(user.allowed_locations != null)
    return user.allowed_locations!.values.any((value) => value.contains(number));
  return false;
}