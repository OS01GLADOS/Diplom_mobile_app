import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/screens/offices/small_office_statistic.dart';
import 'package:diplom_mobile_app/utils/offices/offices_schema.dart';
import 'package:flutter/material.dart';

class OfficesListItem extends StatelessWidget {
  OfficesListItem({required this.office});

  final OfficesSchema office;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: ColorConstants.lightGreen,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                office.address,
                style: TextStyle(
                  color: ColorConstants.usualGreenUsualText,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Text(
                "Свободно: " + office.number_of_free_workspaces.toString()),
          ),
          SmallOfficeStatistic(fillValue: office.percent_of_free_workspaces,)
        ],
      ),
    );
  }
}
