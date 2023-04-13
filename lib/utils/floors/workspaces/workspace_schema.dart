class Workspace {
  int id;
  int number;
  String status;
  String? occupationType;
  int room;
  String roomNumber;
  int? employee;
  String? employeeName;
  DateTime? occupationStartDate;
  DateTime? occupationEndDate;
  List<List<double>> coordinates;
  int rotateDegree;
  String? comment;
  List<OccupationRequest>? bookedStatus;
  List<OccupationRequest>? activeRequests;

  Workspace({
    required this.id,
    required this.number,
    required this.status,
    required this.occupationType,
    required this.room,
    required this.roomNumber,
    required this.employee,
    required this.employeeName,
    required this.occupationStartDate,
    required this.occupationEndDate,
    required this.coordinates,
    required this.rotateDegree,
    required this.comment,
    this.bookedStatus,
    this.activeRequests,
  });

  String translateWorkspaceStatus() {
    switch (status) {
      case "Free":
        return "Свободно";
      case "Reserved":
        return "Зарезервировано";
      case "Booked":
        return "Забронировано";
      case "Occupied":
        return "Занято";
      case "Remote":
        return "Виртуальное";
      default:
        return status;
    }
  }

  factory Workspace.fromJson(Map<String, dynamic> json) {
    var coordinateList = json['coordinates'] as List;
    List<List<double>> coordinates =
    coordinateList.map((i) => List<double>.from(i)).toList();

    List<dynamic>? activeRequestsList = json['active_requests'] as List?;
    List<OccupationRequest>? activeRequests;
    if (activeRequestsList != null) {
      activeRequests = activeRequestsList
          .map((request) => OccupationRequest.fromJson(request))
          .toList();
    }

    List<dynamic>? bookedStatusList = json['booked_status'] as List?;
    List<OccupationRequest>? bookedStatus;
    if (activeRequestsList != null) {
      bookedStatus = bookedStatusList
          ?.map((request) => OccupationRequest.fromJson(request))
          .toList();
    }


    return Workspace(
      id: json['id'],
      number: json['number'],
      status: json['status'],
      occupationType: json['occupation_type'],
      room: json['room'],
      roomNumber: json['room_number'],
      employee: json['employee'] != null ? json['employee']['id'] : null,
      employeeName:
      json['employee'] != null ? json['employee']['preferred_name'] : null,
      occupationStartDate: json['occupation_start_date'] != null
          ? DateTime.parse(json['occupation_start_date'])
          : null,
      occupationEndDate: json['occupation_end_date'] != null
          ? DateTime.parse(json['occupation_end_date'])
          : null,
      coordinates: coordinates,
      rotateDegree: json['rotate_degree'],
      comment: json['comment'],
      bookedStatus: bookedStatus,
      activeRequests: activeRequests,
    );
  }
}
class OccupationRequest {
  final String preferredName;
  final int workspace;
  final DateTime startDate;
  final DateTime endDate;

  OccupationRequest({
    required this.preferredName,
    required this.workspace,
    required this.startDate,
    required this.endDate,
  });

  factory OccupationRequest.fromJson(Map<String, dynamic> json) {
    return OccupationRequest(
      preferredName: json['employee']['preferred_name'],
      workspace: json['workspace'],
      startDate: DateTime.parse(json['occupation_start_date']),
      endDate: DateTime.parse(json['occupation_end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['employee'] = {'preferred_name': this.preferredName};
    data['workspace'] = this.workspace;
    data['occupation_start_date'] = this.startDate.toIso8601String();
    data['occupation_end_date'] = this.endDate.toIso8601String();
    return data;
  }
}