import 'package:flutter/material.dart';

class Utils {
  static Color hexToColor(String hex) {
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }
}
