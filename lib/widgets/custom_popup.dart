import 'package:flutter/material.dart';

Future<void> showCustomPopup({
  required BuildContext context,
  required Widget icon,
  required String title,
  required String message,
  required String confirmButtonText,
  required VoidCallback onConfirmPressed,
  String? cancelButtonText,
  VoidCallback? onCancelPressed,
  Color? titleColor,
  Color? messageColor,
  List<Color>? confirmButtonGradientColors,
  Color? cancelButtonColor,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomPopup(
        icon: icon,
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        onConfirmPressed: onConfirmPressed,
        cancelButtonText: cancelButtonText,
        onCancelPressed: onCancelPressed,
        titleColor: titleColor,
        messageColor: messageColor,
        confirmButtonGradientColors: confirmButtonGradientColors,
        cancelButtonColor: cancelButtonColor,
      );
    },
  );
}

class CustomPopup extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final String confirmButtonText;
  final VoidCallback onConfirmPressed;
  final String? cancelButtonText;
  final VoidCallback? onCancelPressed;
  final Color? titleColor;
  final Color? messageColor;
  final List<Color>? confirmButtonGradientColors;
  final Color? cancelButtonColor;

  const CustomPopup({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.onConfirmPressed,
    this.cancelButtonText,
    this.onCancelPressed,
    this.titleColor,
    this.messageColor,
    this.confirmButtonGradientColors,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: messageColor ?? Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // NOVO: Método para construir apenas o botão de confirmação com gradiente
  Widget _buildConfirmButton(BuildContext context) {
    final List<Color> colors = (confirmButtonGradientColors != null && confirmButtonGradientColors!.isNotEmpty)
        ? confirmButtonGradientColors!
        : [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark];

    return Container(
      height: 48, // Altura padrão
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onConfirmPressed,
            child: Center(
              child: Text(
                confirmButtonText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cancelStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      foregroundColor: cancelButtonColor,
      fixedSize: const Size.fromHeight(48),
    );

    if (cancelButtonText != null && onCancelPressed != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancelPressed,
              style: cancelStyle,
              child: Text(cancelButtonText!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildConfirmButton(context),
          ),
        ],
      );
    } else {
      return _buildConfirmButton(context);
    }
  }
}