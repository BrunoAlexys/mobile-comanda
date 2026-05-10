import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomRateButton extends StatefulWidget {
  final int id;
  final String text;
  final Color defaultColor;
  final Color clickedColor;
  final Color defaultTextColor;
  final Color clickedTextColor;
  final IconData icon;
  final double feePercentage;
  final VoidCallback? onTap;

  const CustomRateButton({
    super.key,
    required this.id,
    required this.text,
    this.defaultColor = Colors.white,
    this.clickedColor = const Color(0xFF2C3EAA),
    this.defaultTextColor = Colors.black,
    this.clickedTextColor = Colors.white,
    this.icon = Icons.add,
    required this.feePercentage,
    this.onTap,
  });

  @override
  State<CustomRateButton> createState() => _CustomRateButtonState();
}

class _CustomRateButtonState extends State<CustomRateButton> {
  final OrderStore _orderStore = locator<OrderStore>();

  late final AppliedFee _baseFee;

  @override
  void initState() {
    super.initState();
    _baseFee = AppliedFee(
      id: widget.id,
      name: widget.text,
      percentage: widget.feePercentage,
    );
  }

  bool get _isClicked {
    return _orderStore.appliedFees.any((fee) => fee.id == widget.id);
  }

  void _toggleFee() {
    final feeToToggle = AppliedFee(
      id: widget.id,
      name: widget.text,
      percentage: widget.feePercentage,
    );

    if (_isClicked) {
      _orderStore.removeFee(feeToToggle);
    } else {
      _orderStore.addFee(feeToToggle);
    }

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return GestureDetector(
          onTap: _toggleFee,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: _isClicked ? widget.clickedColor : widget.defaultColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    color: _isClicked
                        ? widget.clickedTextColor
                        : widget.defaultTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Material(
                    color: _isClicked ? Colors.white : const Color(0xFF3B5BEE),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Icon(
                      Icons.add,
                      color: _isClicked
                          ? const Color(0xFF3B5BEE)
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
