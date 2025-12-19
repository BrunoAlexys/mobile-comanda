import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_comanda/model/order.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_order_status.dart';

class CustomOrder extends StatefulWidget {
  final List<Order> orders;
  final int? tableNumber;
  final Widget? child;
  final DateTime? time;

  const CustomOrder({
    super.key,
    required this.orders,
    this.tableNumber,
    this.child,
    this.time,
  });

  @override
  State<CustomOrder> createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(CustomOrder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.time != oldWidget.time) {
      _timer?.cancel();
      if (widget.time != null) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double totalOrderPrice = widget.orders.fold(
      0.0,
      (sum, order) => sum + order.finalTotalPrice!,
    );

    final int displayTableNumber =
        widget.tableNumber ?? widget.orders.first.tableNumber;
    final String displayStatus = widget.orders.first.status != null
        ? widget.orders.first.status!
        : '';

    final OrderStatus statusEnum = OrderStatus.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toUpperCase() ==
          displayStatus.toUpperCase(),
      orElse: () => OrderStatus.pending,
    );

    final String orderId =
        widget.orders.first.id?.toString().padLeft(4, '0') ??
        displayTableNumber.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Utils.hexToColor(AppColors.primaryColor),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#$orderId - Mesa $displayTableNumber',
                      style: TextStyle(
                        color: Utils.hexToColor(AppColors.burgundy),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    widget.time != null
                        ? Text(
                            'Pronto ${Utils.formatTime(widget.time!)}',
                            style: TextStyle(
                              color: Utils.hexToColor(
                                AppColors.grayColorSecondary,
                              ),
                            ),
                          )
                        : Text(''),
                  ],
                ),
                Spacer(),
                displayStatus.isNotEmpty
                    ? CustomOrderStatus.buildStatusBadge(statusEnum)
                    : SizedBox.shrink(),
              ],
            ),

            widget.time != null ? SizedBox(height: 8) : SizedBox.shrink(),

            if (widget.child != null) widget.child!,

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  Utils.formatPrice(totalOrderPrice),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
