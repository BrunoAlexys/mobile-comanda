import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomProductItem extends StatelessWidget {
  final int productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CustomProductItem({
    super.key,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Utils.hexToColor(AppColors.primaryColor),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Utils.hexToColor(AppColors.burgundy),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  productDescription,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Utils.hexToColor('545454'),
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  Utils.formatPrice(productPrice),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Utils.hexToColor(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                color: quantity > 0
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                onTap: onDecrement,
              ),
              const SizedBox(width: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Utils.hexToColor(AppColors.burgundy),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              _buildQuantityButton(
                icon: Icons.add,
                color: Utils.hexToColor(AppColors.primaryColor),
                onTap: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
