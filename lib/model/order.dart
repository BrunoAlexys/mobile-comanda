import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/model/order_item.dart';

class Order {
  final int? id;
  final int tableNumber;
  final List<OrderItem> items;
  final String? additionalComment;
  final List<AppliedFee>? appliedFees;
  final double? totalOrderPrice;
  final double? totalFeesValue;
  final double? finalTotalPrice;
  final DateTime? createdAt;
  final String? status;

  Order({
    this.id,
    required this.tableNumber,
    required this.items,
    this.additionalComment,
    this.appliedFees,
    this.totalOrderPrice,
    this.totalFeesValue,
    this.finalTotalPrice,
    this.createdAt,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tableNumber': tableNumber,
      'additionalComment': additionalComment,
      'status': status,

      'items': items.map((item) {
        return {'menuId': item.menu.id, 'quantity': item.quantity};
      }).toList(),

      'appliedFeeIds': appliedFees?.map((fee) => fee.id).toList() ?? [],
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      tableNumber: json['tableNumber'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      additionalComment: json['additionalComment'],
      appliedFees: json['appliedFees'] != null
          ? (json['appliedFees'] as List)
                .map((fee) => AppliedFee.fromJson(fee))
                .toList()
          : [],
      totalOrderPrice: (json['totalOrderPrice'] as num).toDouble(),
      totalFeesValue: (json['totalFeesValue'] as num).toDouble(),
      finalTotalPrice: (json['finalTotalPrice'] as num).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      status: json['status'] ?? 'PENDING',
    );
  }
}
