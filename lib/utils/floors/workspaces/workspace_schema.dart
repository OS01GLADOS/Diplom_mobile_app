class Workspace {
  int id;
  int number;
  String status;
  String? occupationType;
  int room;
  String roomNumber;
  String? employee;
  String? occupationStartDate;
  String? occupationEndDate;
  List<List<double>> coordinates;
  int rotateDegree;
  String? comment;
  List<String> bookedStatus;
  List<dynamic> activeRequests;

  Workspace({
    required this.id,
    required this.number,
    required this.status,
    required this.occupationType,
    required this.room,
    required this.roomNumber,
    required this.employee,
    required this.occupationStartDate,
    required this.occupationEndDate,
    required this.coordinates,
    required this.rotateDegree,
    required this.comment,
    required this.bookedStatus,
    required this.activeRequests,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    var coordinateList = json['coordinates'] as List;
    List<List<double>> coordinates =
    coordinateList.map((i) => List<double>.from(i)).toList();

    return Workspace(
      id: json['id'],
      number: json['number'],
      status: json['status'],
      occupationType: json['occupation_type'],
      room: json['room'],
      roomNumber: json['room_number'],
      employee: json['employee'],
      occupationStartDate: json['occupation_start_date'],
      occupationEndDate: json['occupation_end_date'],
      coordinates: coordinates,
      rotateDegree: json['rotate_degree'],
      comment: json['comment'],
      bookedStatus: List<String>.from(json['booked_status']),
      activeRequests: json['active_requests'],
    );
  }
}