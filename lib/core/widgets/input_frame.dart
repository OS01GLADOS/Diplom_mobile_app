import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:flutter/material.dart';


class InputFrameWidget extends StatefulWidget {
  InputFrameWidget(
      this.label,
      this.child
      );
  String label;

  Widget child;

  @override
  State<InputFrameWidget> createState() => new InputFrameWidgetState();

}


class InputFrameWidgetState extends State<InputFrameWidget> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorConstants.lightGreen,
                width: 1
            ),
            color: ColorConstants.whiteBackground,
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: widget.child,
        ),
        Positioned(
          left: 30,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: ColorConstants.whiteBackground,
            child: Text(
              widget.label,
              style: TextStyle(
                  color: ColorConstants.lightGreen,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ],
    );
  }
}
