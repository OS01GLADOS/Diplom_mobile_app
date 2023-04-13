class Room {
  int id;
  String number;
  String layout;
  List<List<double>> containerCoordinates;
  int floor;
  String roomType;
  bool isOur;

  Room({
    required this.id,
    required this.number,
    required this.layout,
    required this.containerCoordinates,
    required this.floor,
    required this.roomType,
    required this.isOur,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      number: json['number'],
      layout: json['layout'],
      containerCoordinates: List.from(json['container_coordinates'])
          .map((coord) => List<double>.from(coord))
          .toList(),
      floor: json['floor'],
      roomType: json['room_type'],
      isOur: json['our'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['layout'] = this.layout;
    data['container_coordinates'] = this.containerCoordinates;
    data['floor'] = this.floor;
    data['room_type'] = this.roomType;
    data['our'] = this.isOur;
    return data;
  }
}