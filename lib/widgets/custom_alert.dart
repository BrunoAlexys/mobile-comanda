import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

enum AlertPosition { top, bottom }

class CustomAlert {
  CustomAlert._();

  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    AlertPosition position = AlertPosition.bottom,
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.check_circle_outline,
      backgroundColor: Utils.hexToColor(AppColors.greenAlert),
      position: position,
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    AlertPosition position = AlertPosition.bottom,
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.error_outline,
      backgroundColor: Utils.hexToColor(AppColors.redAlert),
      position: position,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    AlertPosition position = AlertPosition.bottom,
  }) {
    _showAlert(
      context: context,
      message: message,
      duration: duration,
      iconData: Icons.warning_amber_rounded,
      backgroundColor: Utils.hexToColor(AppColors.yellowAlert),
      position: position,
    );
  }

  static void _showAlert({
    required BuildContext context,
    required String message,
    required IconData iconData,
    required Color backgroundColor,
    required Duration duration,
    required AlertPosition position,
  }) {
    if (position == AlertPosition.bottom) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final overlay = Overlay.of(context);

      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 24,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: AnimatedSlide(
              offset: const Offset(0, -0.2),
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(iconData, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      Future.delayed(duration, () => overlayEntry.remove());
    }
  }
}
