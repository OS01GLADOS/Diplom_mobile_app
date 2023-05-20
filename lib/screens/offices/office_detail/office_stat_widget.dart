import 'package:flutter/material.dart';

import 'big_office_statistic.dart';

class OfficeStatsWidget extends StatelessWidget {
  final int numberOfReservedWorkspaces;
  final int numberOfBookedWorkspaces;
  final int numberOfOccupiedWorkspaces;
  final int numberOfFreeWorkspaces;
  final int numberOfRemoteWorkspaces;

  const OfficeStatsWidget({
    Key? key,
    required this.numberOfReservedWorkspaces,
    required this.numberOfBookedWorkspaces,
    required this.numberOfOccupiedWorkspaces,
    required this.numberOfFreeWorkspaces,
    required this.numberOfRemoteWorkspaces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsRow(
          title: 'Занято мест',
          value: numberOfOccupiedWorkspaces.toString(),
          color: Colors.redAccent,
        ),
        _buildStatsRow(
          title: 'Забронировано мест',
          value: numberOfBookedWorkspaces.toString(),
          color: Colors.amber,
        ),
        _buildStatsRow(
          title: 'Зарезервировано мест',
          value: numberOfReservedWorkspaces.toString(),
          color: Colors.deepPurpleAccent,
        ),
        _buildStatsRow(
          title: 'Свободно мест',
          value: numberOfFreeWorkspaces.toString(),
          color: Colors.greenAccent,
        ),
        _buildStatsRow(
          title: 'виртуальные места',
          value: numberOfRemoteWorkspaces.toString(),
          color: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildStatsRow({
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
