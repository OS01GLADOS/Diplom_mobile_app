class Booking {
  int id;
  DateTime occupationStartDate;
  DateTime occupationEndDate;
  String requestType;
  String status;
  DateTime creationTime;
  int employeeId;
  String employeeName;
  int workspaceId;
  int workspaceNumber;
  int officeManagerId;
  String officeManagerName;
  String room;
  int floor;
  String office;
  String? comment;
  String? managerComment;
  String location;

  Booking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        occupationStartDate = DateTime.parse(json['occupation_start_date']),
        occupationEndDate = DateTime.parse(json['occupation_end_date']),
        requestType = json['request_type'],
        status = json['status'],
        creationTime = DateTime.parse(json['creation_time']),
        employeeId = json['employee']['id'],
        employeeName = json['employee']['preferred_name'],
        workspaceId = json['workspace']['id'],
        workspaceNumber = json['workspace']['number'],
        officeManagerId = json['office_manager']['id'],
        officeManagerName = json['office_manager']['preferred_name'],
        room = json['room'],
        floor = json['floor'],
        office = json['office'],
        comment = json['comment'],
        managerComment = json['manager_comment'],
        location = json['location'];
}