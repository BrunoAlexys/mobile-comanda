import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;
  final String text;
  final List<Color>? gradientColors;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.icon,
    this.borderRadius,
    required this.text,
    this.gradientColors,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // LÓGICA CORRIGIDA: Usa as cores do tema se gradientColors for nulo OU VAZIO.
    final List<Color> colors = (gradientColors != null && gradientColors!.isNotEmpty)
        ? gradientColors!
        : [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark];

    final activeGradient = LinearGradient(
      colors: colors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final inactiveGradient = LinearGradient(
      colors: [Colors.grey.shade300, Colors.grey.shade400],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      key: const Key('custom_button_container'),
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        gradient: isEnabled ? activeGradient : inactiveGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        boxShadow: isEnabled && colors.isNotEmpty
            ? [
                BoxShadow(
                  color: colors.first.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

