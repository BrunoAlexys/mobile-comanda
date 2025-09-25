import 'package:flutter/material.dart';

import '../util/utils.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? orderTotal;
  final Widget? icon;
  final String text;
  final List<String>? gradientColors;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.orderTotal,
    this.icon,
    this.borderRadius,
    required this.text,
    this.gradientColors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = orderTotal != null && orderTotal! > 0;

    final List<Color> colors = gradientColors
        ?.map((hex) => Utils.hexToColor(hex))
        .toList() ??
        [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark];

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
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        gradient: isEnabled ? activeGradient : inactiveGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
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