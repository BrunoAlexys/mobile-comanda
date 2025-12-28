import 'package:mobile_comanda/repository/dio_client.dart';

class OrderRepository {
  final DioClient _dioClient;

  OrderRepository(this._dioClient);

  Future<void> sendOrder(Map<String, dynamic> orderData) async {
    try {
      await _dioClient.post('/orders', data: orderData);
    } catch (e) {
      rethrow;
    }
  }
}
