class OfficesSchema {
  final int id;
  final int location;
  final String address;

  final int number_of_free_workspaces;
  final double percent_of_free_workspaces;

  const OfficesSchema(
      {required this.id,
      required this.location,
      required this.address,
      required this.number_of_free_workspaces,
      required this.percent_of_free_workspaces});

  factory OfficesSchema.fromJson(Map<String, dynamic> json) {
    return OfficesSchema(
      id: json['id'],
      location: json['location'],
      address: json['address'],
      number_of_free_workspaces: json['number_of_free_workspaces'],
      percent_of_free_workspaces: json['percent_of_free_workspaces'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'address': address,
        'number_of_free_workspaces': number_of_free_workspaces,
        'percent_of_free_workspaces': percent_of_free_workspaces,
      };
}
