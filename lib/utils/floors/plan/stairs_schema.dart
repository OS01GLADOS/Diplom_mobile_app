class Stair {
  int id;
  String layout;
  List<List<double>> containerCoordinates;
  int floor;

  Stair({
    required this.id,
    required this.layout,
    required this.containerCoordinates,
    required this.floor,
  });

  factory Stair.fromJson(Map<String, dynamic> json) {
    return Stair(
      id: json['id'],
      layout: json['layout'],
      containerCoordinates: List.from(json['container_coordinates'])
          .map((coord) => List<double>.from(coord))
          .toList(),
      floor: json['floor'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['layout'] = this.layout;
    data['container_coordinates'] = this.containerCoordinates;
    data['floor'] = this.floor;
    return data;
  }
}