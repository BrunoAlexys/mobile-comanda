import 'package:mobile_comanda/model/menu.dart';

class OrderItem {
  final int? id;
  final Menu menu;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.menu,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'menu': {'id': menu.id},
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      menu: Menu.fromJson(json['menu']),
    );
  }
}
