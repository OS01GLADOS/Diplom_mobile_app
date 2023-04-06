class RetrieveRoles {
  final RetrieveRolePerson person;
  final List permissions;
  final Map? allowed_locations;

  const RetrieveRoles({
    required this.person,
    required this.permissions,
    required this.allowed_locations,
  });

  factory RetrieveRoles.fromJson(Map<String, dynamic> json) {
    return RetrieveRoles(
      person: RetrieveRolePerson.fromJson(json['person']) ,
      permissions: json['permissions'],
      allowed_locations: json['allowed_locations'],
    );
  }

  Map<String, dynamic> toJson() => {
    'person':person.toJson(),
    'permissions': permissions,
    'allowed_locations': allowed_locations,
  };
}

class RetrieveRolePerson{

  final int id;
  final String name_eng;
  final String surname_eng;
  final String preferred_name;
  final String email;
  final String department;
  final bool is_have_workspace;

  const RetrieveRolePerson({
    required this.id,
    required this.name_eng,
    required this.surname_eng,
    required this.preferred_name,
    required this.email,
    required this.department,
    required this.is_have_workspace
  });

  factory RetrieveRolePerson.fromJson(Map<String, dynamic> json) {
    return RetrieveRolePerson(
      id: json['id'],
      name_eng: json['name_eng'],
      surname_eng: json['surname_eng'],
      preferred_name: json['preferred_name'],
      email: json['email'],
      department: json['department'],
      is_have_workspace: json['is_have_workspace'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name_eng': name_eng,
    'surname_eng': surname_eng,
    'preferred_name': preferred_name,
    'email': email,
    'department': department,
    'is_have_workspace': is_have_workspace,
  };
}