import 'package:flutter/material.dart';

class Utils {
  static Color hexToColor(String hex) {
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  static String formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static String formatTime(DateTime pastTime) {
    final Duration difference = DateTime.now().difference(pastTime);

    if (difference.inDays > 0) {
      return 'há ${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} hr${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} min';
    } else {
      return 'agora mesmo';
    }
  }
}
