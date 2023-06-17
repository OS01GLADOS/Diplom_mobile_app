import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/screens/offices/office_detail/office_detail_statistic_round.dart';
import 'package:flutter/material.dart';
import 'big_office_statistic.dart';

class OfficeStatsWidget extends StatelessWidget {

  double getPercent(int number){
    if (number == 0 ) return 0.0;
    var divisioner  = numberOfReservedWorkspaces+numberOfBookedWorkspaces+numberOfOccupiedWorkspaces+numberOfFreeWorkspaces+numberOfRemoteWorkspaces;
    if (divisioner == 0) divisioner = 1;
    return number / divisioner*100;
  }

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
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatsBox(
            children: [
              _buildStatsRow(
                title: 'Свободно',
                value: numberOfFreeWorkspaces.toString(),
                color: ColorConstants.workspaceFreeColor,
              ),
              OfficeDetailStatisticRound(
                fillValue: getPercent(numberOfFreeWorkspaces),
                fillColor: ColorConstants.workspaceFreeColor,
              )
            ]
          ),
          _buildStatsBox(
              children: [
                _buildStatsRow(
                  title: 'Занято',
                  value: numberOfOccupiedWorkspaces.toString(),
                  color: ColorConstants.workspaceOccupiedColor,
                ),
                OfficeDetailStatisticRound(
                  fillValue: getPercent(numberOfOccupiedWorkspaces),
                  fillColor: ColorConstants.workspaceOccupiedColor,
                )
              ]
          ),
          _buildStatsBox(
              children: [
                _buildStatsRow(
                  title: 'Забронировано',
                  value: numberOfBookedWorkspaces.toString(),
                  color: ColorConstants.workspaceBookedColor,
                ),
                OfficeDetailStatisticRound(
                  fillValue: getPercent(numberOfBookedWorkspaces),
                  fillColor: ColorConstants.workspaceBookedColor,
                )
              ]
          ),

        ],
      );

  }
  Widget _buildStatsBox({
    required List<Widget> children
  }) {
    return
      Container(
        width: 120,
        height: 140,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children
        ),
      );
  }



  Widget _buildStatsRow({
    required String title,
    required String value,
    required Color color,
  }) {
    return
      Column(
        children: [
          Text(
            "$title",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          )
        ],
      )
      ;
  }
}
