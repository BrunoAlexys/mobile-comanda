import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomCategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomCategoryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        backgroundColor: isSelected
            ? Utils.hexToColor('0022CA')
            : Utils.hexToColor('F3F4F6'),
        fixedSize: const Size(150, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Utils.hexToColor('666666'),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
