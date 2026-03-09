import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_photo_menu_item.dart';

class CustomProductItem extends StatelessWidget {
  final int productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String? imageUrl;

  const CustomProductItem({
    super.key,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomPhotoMenuItem(
                    url: imageUrl ?? '',
                    width: 90,
                    height: 90,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Utils.hexToColor('1A1A1A'),
                        ),
                      ),
                      Text(
                        productDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: Utils.hexToColor('666666'),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$ ${productPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Utils.hexToColor('1A1A1A'),
                            ),
                          ),
                          Row(
                            children: [
                              HoldableButton(
                                icon: Icons.remove,
                                color: Utils.hexToColor('EAEAEA'),
                                iconColor: Utils.hexToColor('1A1A1A'),
                                onTap: onDecrement,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Utils.hexToColor('1A1A1A'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              HoldableButton(
                                icon: Icons.add,
                                color: Utils.hexToColor('0022CA'),
                                iconColor: Colors.white,
                                onTap: onIncrement,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Utils.hexToColor('EAEAEA')),
        ],
      ),
    );
  }
}

class HoldableButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const HoldableButton({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<HoldableButton> createState() => _HoldableButtonState();
}

class _HoldableButtonState extends State<HoldableButton> {
  Timer? _timer;

  void _startHolding() {
    widget.onTap();

    _timer = Timer(const Duration(milliseconds: 400), () {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        widget.onTap();
      });
    });
  }

  void _stopHolding() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopHolding();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHolding(),
      onTapUp: (_) => _stopHolding(),
      onTapCancel: () => _stopHolding(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
        child: Icon(widget.icon, color: widget.iconColor, size: 20),
      ),
    );
  }
}
