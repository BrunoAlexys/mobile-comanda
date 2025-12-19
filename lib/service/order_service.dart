import 'package:mobile_comanda/repository/order_repository.dart';

class OrderService {
  final OrderRepository _orderRepository;

  OrderService(this._orderRepository);

  Future<void> sendOrder(Map<String, dynamic> orderData) async {
    await _orderRepository.sendOrder(orderData);
  }
}
