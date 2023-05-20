import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

final ButtonStyle default_style = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.lightGreen,),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered))
        return ColorConstants.lightGreen; //<-- SEE HERE
      return ColorConstants
          .saladGreenBackground; // Defer to the widget's default.
    },
  ),
  minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(40)),
);