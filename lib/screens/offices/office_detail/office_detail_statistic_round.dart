import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class OfficeDetailStatisticRound extends StatefulWidget {
  final double fillValue;
  final Color fillColor;

  const OfficeDetailStatisticRound({Key? key, required this.fillValue, required this.fillColor}) : super(key: key);

  @override
  _OfficeDetailStatisticRoundState createState() => _OfficeDetailStatisticRoundState();
}

class _OfficeDetailStatisticRoundState extends State<OfficeDetailStatisticRound>
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
                  _animation.value == 0 ? ColorConstants.whiteBackground : widget.fillColor,
                ),
                backgroundColor:
                _animation.value == 0 ? ColorConstants.whiteBackground : ColorConstants.whiteBackground,
              );
            },
          ),
          Center(
            child: Text(
              "${widget.fillValue.toInt()}%",
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: widget.fillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}