import 'package:dio/dio.dart';
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

  Future<String> getNextOrderNumber(int adminId) async {
    try {
      final response = await _dioClient.get(
        '/orders/next-number/$adminId',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data.toString();
    } catch (e) {
      rethrow;
    }
  }
}
