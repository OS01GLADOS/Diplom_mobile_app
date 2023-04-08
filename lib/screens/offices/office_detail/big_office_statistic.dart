import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final double reservedPercent;
  final double bookedPercent;
  final double occupiedPercent;
  final double freePercent;
  final double remotePercent;

  const DonutChart({
    Key? key,
    required this.reservedPercent,
    required this.bookedPercent,
    required this.occupiedPercent,
    required this.freePercent,
    required this.remotePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

      ],
    );
  }
}