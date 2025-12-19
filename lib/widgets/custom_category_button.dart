import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomCategoryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomCategoryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon!,
          size: 26,
          color: isSelected
              ? Colors.white
              : Utils.hexToColor(AppColors.burgundy),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Utils.hexToColor(AppColors.burgundy),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: isSelected
              ? Utils.hexToColor(AppColors.primaryColor)
              : Colors.white,
          fixedSize: const Size(180, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : Utils.hexToColor(AppColors.burgundy),
              width: 1,
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor: Utils.hexToColor(AppColors.primaryColor),
        fixedSize: const Size(180, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
