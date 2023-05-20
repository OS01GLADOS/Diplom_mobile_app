import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class SmallOfficeStatistic extends StatefulWidget {
  final double fillValue;

  const SmallOfficeStatistic({Key? key, required this.fillValue}) : super(key: key);

  @override
  _SmallOfficeStatisticState createState() => _SmallOfficeStatisticState();
}

class _SmallOfficeStatisticState extends State<SmallOfficeStatistic>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation =
        Tween<double>(begin: 0, end: widget.fillValue).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return CircularProgressIndicator(
                value: _animation.value / 100,
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _animation.value == 0 ? ColorConstants.saladGreenBackground : ColorConstants.lightGreen,
                ),
                backgroundColor:
                _animation.value == 0 ? ColorConstants.saladGreenBackground : ColorConstants.saladGreenBackground,
              );
            },
          ),
          Center(
            child: Text(
              "${widget.fillValue.toInt()}%",
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
