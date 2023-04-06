import 'package:flutter/material.dart';

import '../../utils/offices/offices_schema.dart';
import 'office_list_item.dart';

class OfficesList extends StatelessWidget {
  OfficesList({required this.offices});

  final List<OfficesSchema> offices;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: offices.length,
        itemBuilder: (context, index) {
          return OfficesListItem(office: offices[index]);
        },
      ),
    );
  }
}
