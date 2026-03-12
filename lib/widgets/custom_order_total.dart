import 'package:flutter/material.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/model/order_item.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';

class CustomOrderTotal extends StatelessWidget {
  final List<OrderItem> order;
  final bool isOrderValid;
  final VoidCallback? onNext;
  final double finalTotalPrice;
  final String? textButton;
  final bool isLoading;

  const CustomOrderTotal({
    Key? key,
    required this.order,
    required this.isOrderValid,
    required this.finalTotalPrice,
    this.textButton,
    this.onNext,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderStore _orderStore = locator<OrderStore>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Total do Pedido:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Utils.hexToColor('3B3B3B'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Taxa:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Utils.hexToColor('717076'),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      Utils.formatPrice(finalTotalPrice),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Utils.hexToColor(AppColors.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      Utils.formatPrice(_orderStore.totalFeesValue),
                      style: TextStyle(
                        fontSize: 12,
                        color: Utils.hexToColor('717076'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: textButton ?? 'Avançar',
            onPressed: (isOrderValid && !isLoading) ? onNext : null,
            isEnabled: isOrderValid && !isLoading,
          ),
        ],
      ),
    );
  }
}
