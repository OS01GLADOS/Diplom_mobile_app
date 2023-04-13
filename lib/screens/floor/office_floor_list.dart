import 'package:diplom_mobile_app/utils/floors/floor_schema.dart';
import 'package:diplom_mobile_app/utils/floors/get_office_floors.dart';
import 'package:flutter/material.dart';

import 'floor_detail.dart';


class FloorsListWidget extends StatelessWidget {

  final int office_id;

  FloorsListWidget({required this.office_id});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetFloorModel>>(
      future: get_office_floors(office_id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          final floors = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: floors.length,
            itemBuilder: (context, index) {
              final floor = floors[index];
              return Card(
                child: ListTile(
                  title: Text(floor.toString()),
                  subtitle: Text(floor.subtitle()),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FloorDetailWidget(floor: floor,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}