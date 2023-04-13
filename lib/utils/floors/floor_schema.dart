import 'dart:convert';

class GetFloorModel {
  int id;
  int number;
  int freeWorkspaces;
  int remoteWorkspaces;
  bool isVirtual;


  GetFloorModel({
    required this.id,
    required this.number,
    required this.isVirtual,
    required this.freeWorkspaces,
    required this.remoteWorkspaces,
  });

  factory GetFloorModel.fromJson(Map<String, dynamic> json) {
    return GetFloorModel(
      id: json['id'],
      number: json['number'],
      isVirtual: json['is_virtual'],
      freeWorkspaces: json['number_of_free_workspaces'],
      remoteWorkspaces: json['number_of_remote_workspaces']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'is_virtual': isVirtual,
      'number_of_free_workspaces' : freeWorkspaces,
      'number_of_remote_workspaces' : remoteWorkspaces,
    };
  }

  String subtitle()=> isVirtual ? "Всего $remoteWorkspaces" : "Свободно $freeWorkspaces";

  @override
  String toString()
    => isVirtual ? "Виртуальный этаж" : "Этаж $number";
}