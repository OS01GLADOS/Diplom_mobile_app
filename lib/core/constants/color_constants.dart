import 'dart:ui';
import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color redError = hexToColor('#ed2939');
  static Color whiteBackground = Colors.white;
  static Color darkGreenHeaderText = hexToColor('#012010');
  static Color usualGreenUsualText = hexToColor('#1b511a');
  static Color lightGreen = hexToColor('#6fa545');
  static Color saladGreenBackground = hexToColor('#c9e5ab');
  static Color wheatBackground = hexToColor('#e3e16c');

  static Color requestInProgress = hexToColor("#63B3ED");
  static Color requestApproved = hexToColor("#00A854");
  static Color requestRejected = hexToColor("#D9534F");
  static Color requestDelayed = hexToColor("#FF8C00");
  static Color requestCanceled = hexToColor("#6c757d");



}