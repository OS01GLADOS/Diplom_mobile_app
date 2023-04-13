import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

Color getWorkspaceColor(String status) {
  switch (status) {
    case "Free":
      return ColorConstants.workspaceFreeColor;
    case "Reserved":
      return ColorConstants.workspaceReservedColor;
    case "Booked":
      return ColorConstants.workspaceBookedColor;
    case "Occupied":
      return ColorConstants.workspaceOccupiedColor;
    case "Remote":
      return ColorConstants.workspaceRemoteColor;
    default:
      return Colors.grey;
  }
}