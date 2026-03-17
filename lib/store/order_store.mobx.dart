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
  String orderNumber = '';

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

  int getQuantity(int productId) {
    final index = orders.indexWhere((item) => item.menu.id == productId);
    return index >= 0 ? orders[index].quantity : 0;
  }

  @action
  Future<void> fetchNextOrderNumber(int adminId) async {
    try {
      orderNumber = await _orderService.getNextOrderNumber(adminId);
    } catch (e) {
      orderNumber = '0000';
    }
  }

  @action
  void incrementProduct(Menu menu) {
    final index = orders.indexWhere((item) => item.menu.id == menu.id);

    if (index >= 0) {
      final currentItem = orders[index];
      orders[index] = OrderItem(
        id: currentItem.id,
        menu: currentItem.menu,
        price: currentItem.price,
        quantity: currentItem.quantity + 1,
      );
    } else {
      orders.add(
        OrderItem(id: null, menu: menu, price: menu.price, quantity: 1),
      );
    }
  }

  @action
  void decrementProduct(Menu menu) {
    final index = orders.indexWhere((item) => item.menu.id == menu.id);

    if (index >= 0) {
      final currentItem = orders[index];
      if (currentItem.quantity > 1) {
        orders[index] = OrderItem(
          id: currentItem.id,
          menu: currentItem.menu,
          price: currentItem.price,
          quantity: currentItem.quantity - 1,
        );
      } else {
        orders.removeAt(index);
      }
    }
  }

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
    orders.clear();
    tableNumber = null;
    appliedFees.clear();
    additionalComment = '';
    orderNumber = '';
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
      userId: userId,
    );
  }
}
