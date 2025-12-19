import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/model/menu.dart';
import 'package:mobile_comanda/model/order.dart';
import 'package:mobile_comanda/model/order_item.dart';
import 'package:mobile_comanda/service/order_service.dart';
import 'package:mobx/mobx.dart';

part 'order_store.mobx.g.dart';

class OrderStore = _OrderStore with _$OrderStore;

abstract class _OrderStore with Store {
  final _orderService = locator<OrderService>();

  @observable
  ObservableList<OrderItem> orders = ObservableList<OrderItem>();

  @observable
  int? tableNumber;

  @observable
  ObservableList<AppliedFee> appliedFees = ObservableList<AppliedFee>();

  @observable
  String additionalComment = '';

  @observable
  String loadingMessage = '';

  @computed
  double get totalOrderPrice =>
      orders.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  @computed
  double get totalFeesValue {
    final basePrice = totalOrderPrice;
    return appliedFees.fold(
      0.0,
      (sum, fee) => sum + (basePrice * (fee.percentage / 100)),
    );
  }

  @computed
  double get finalTotalPrice => totalOrderPrice + totalFeesValue;

  @computed
  bool get isOrderValid => orders.isNotEmpty;

  @computed
  bool get isLoading => loadingMessage.isNotEmpty;

  @action
  void addFee(AppliedFee fee) {
    if (!appliedFees.any((f) => f.name == fee.name)) {
      appliedFees.add(fee);
    }
  }

  @action
  void removeFee(AppliedFee fee) {
    appliedFees.removeWhere((f) => f.name == fee.name);
  }

  @action
  void updateOrders(
    Map<int, int> productQuantities,
    List<Map<String, dynamic>> allProducts,
  ) {
    List<OrderItem> newOrders = [];

    productQuantities.forEach((productId, quantity) {
      if (quantity > 0) {
        final productMap = allProducts.firstWhere(
          (p) => p['id'] == productId,
          orElse: () => throw Exception('Product with ID $productId not found'),
        );

        final menu = Menu.fromJson(productMap);

        newOrders.add(
          OrderItem(
            id: null,
            menu: menu,
            price: (productMap['price'] as num).toDouble(),
            quantity: quantity,
          ),
        );
      }
    });

    orders = ObservableList.of(newOrders);
  }

  @action
  void setTableNumber(int? table) {
    tableNumber = table;
  }

  @action
  void setAdditionalComment(String comment) {
    additionalComment = comment;
  }

  @action
  void setLoadingMessage(String message) {
    loadingMessage = message;
  }

  @action
  void clearOrder() {
    orders = ObservableList.of([]);
    tableNumber = null;
    appliedFees = ObservableList.of([]);
    additionalComment = '';
  }

  Future<Order> sendOrder(Order order) async {
    setLoadingMessage('Carregando envio do pedido...');
    try {
      await _orderService.sendOrder(order.toJson());
      await Future.delayed(const Duration(milliseconds: 500));
      return order.copyWith();
    } finally {
      setLoadingMessage('');
    }
  }
}

extension OrderCopyWith on Order {
  Order copyWith({int? id}) {
    return Order(
      tableNumber: tableNumber,
      items: items,
      additionalComment: additionalComment,
      appliedFees: appliedFees,
      totalOrderPrice: totalOrderPrice,
      totalFeesValue: totalFeesValue,
      finalTotalPrice: finalTotalPrice,
      createdAt: createdAt,
      status: status,
    );
  }
}
