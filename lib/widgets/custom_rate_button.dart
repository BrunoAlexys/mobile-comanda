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
    this.clickedColor = Colors.red,
    this.defaultTextColor = Colors.red,
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
    final double calculatedValue =
        _orderStore.totalOrderPrice * widget.feePercentage;

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
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Material(
                    color: _isClicked
                        ? Colors.white
                        : Utils.hexToColor(AppColors.primaryColor),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Icon(
                      Icons.add,
                      color: _isClicked
                          ? Utils.hexToColor(AppColors.primaryColor)
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
