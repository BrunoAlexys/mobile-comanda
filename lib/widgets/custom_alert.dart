import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomAlert {
  CustomAlert._();

  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.check_circle_outline,
      backgroundColor: Utils.hexToColor(AppColors.greenAlert),
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.error_outline,
      backgroundColor: Utils.hexToColor(AppColors.redAlert),
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.warning_amber_rounded,
      backgroundColor: Utils.hexToColor(AppColors.yellowAlert),
    );
  }

  static void _showAlert({
    required BuildContext context,
    required String message,
    required IconData iconData,
    required Color backgroundColor,
    required Duration duration,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
