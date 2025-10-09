import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

enum AlertType {
  sucesso,
  erro,
  aviso,
}

void showCustomAlert({
  required BuildContext context,
  required String message,
  required AlertType type,
  Duration duration = const Duration(seconds: 3),
  String? backgroundColor,
}) {
  Color finalBackgroundColor;
  IconData iconData;

  switch (type) {
    case AlertType.sucesso:
      finalBackgroundColor = Utils.hexToColor(AppColors.greenAlert);
      iconData = Icons.check_circle_outline;
      break;
    case AlertType.erro:
      finalBackgroundColor = Utils.hexToColor(AppColors.redAlert);
      iconData = Icons.error_outline;
      break;
    case AlertType.aviso:
      finalBackgroundColor = Utils.hexToColor(AppColors.yellowAlert);
      iconData = Icons.warning_amber_rounded;
      break;
  }

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
    backgroundColor: finalBackgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.all(16.0),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  );

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}