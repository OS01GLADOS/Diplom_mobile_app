import 'package:diplom_mobile_app/utils/employees/employee_schema.dart';

class Office {
  int id;
  int location;
  String address;
  String? addressEng;
  String postcode;
  int owner;
  int jiraOfficeId;

  Office({
    required this.id,
    required this.location,
    required this.address,
    required this.addressEng,
    required this.postcode,
    required this.owner,
    required this.jiraOfficeId,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'] as int,
      location: json['location'] as int,
      address: json['address'] as String,
      addressEng: json['address_eng'],
      postcode: json['postcode'] as String,
      owner: json['owner'] as int,
      jiraOfficeId: json['jira_office_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['address'] = this.address;
    data['address_eng'] = this.addressEng;
    data['postcode'] = this.postcode;
    data['owner'] = this.owner;
    data['jira_office_id'] = this.jiraOfficeId;
    return data;
  }
}

class OfficeDetail {
  int id;
  int location;
  String address;
  String? addressEng;
  String postcode;
  Employee? owner;
  List<Employee> manager;
  int jiraOfficeId;
  int numberOfReservedWorkspaces;
  int numberOfBookedWorkspaces;
  int numberOfOccupiedWorkspaces;
  int numberOfFreeWorkspaces;
  int numberOfRemoteWorkspaces;

  OfficeDetail({
    required this.id,
    required this.location,
    required this.address,
    required this.addressEng,
    required this.postcode,
    required this.owner,
    required this.manager,
    required this.jiraOfficeId,
    required this.numberOfReservedWorkspaces,
    required this.numberOfBookedWorkspaces,
    required this.numberOfOccupiedWorkspaces,
    required this.numberOfFreeWorkspaces,
    required this.numberOfRemoteWorkspaces,
  });

  factory OfficeDetail.fromJson(Map<String, dynamic> json) {
    return OfficeDetail(
      id: json['id'] as int,
      location: json['location'] as int,
      address: json['address'],
      addressEng: json['address_eng'],
      postcode: json['postcode'] as String,
      owner: Employee.fromJson(json['owner']),
      manager: (json['manager'] as List<dynamic>).map((e) => Employee.fromJson(e)).toList(),
      jiraOfficeId: json['jira_office_id'] as int,
      numberOfReservedWorkspaces: json['number_of_reserved_workspaces'] as int,
      numberOfBookedWorkspaces: json['number_of_booked_workspaces'] as int,
      numberOfOccupiedWorkspaces: json['number_of_occupied_workspaces'] as int,
      numberOfFreeWorkspaces: json['number_of_free_workspaces'] as int,
      numberOfRemoteWorkspaces: json['number_of_remote_workspaces'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['address'] = this.address;
    data['address_eng'] = this.addressEng;
    data['postcode'] = this.postcode;
    data['owner'] =  (this.owner != null)? this.owner!.id:null;
    data['manager'] = this.manager.map((e) => e.id).toList();
    data['jira_office_id'] = this.jiraOfficeId;
    data['number_of_reserved_workspaces'] = this.numberOfReservedWorkspaces;
    data['number_of_booked_workspaces'] = this.numberOfBookedWorkspaces;
    data['number_of_occupied_workspaces'] = this.numberOfOccupiedWorkspaces;
    data['number_of_free_workspaces'] = this.numberOfFreeWorkspaces;
    data['number_of_remote_workspaces'] = this.numberOfRemoteWorkspaces;
    return data;
  }
}