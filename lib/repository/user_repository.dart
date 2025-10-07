import 'package:mobile_comanda/repository/dio_client.dart';

class UserRepository {
  final DioClient _dioClient;

  UserRepository(this._dioClient);

  Future<Map<String, dynamic>> fetchUser(String email) async {
    try {
      final response = await _dioClient.get('/users/$email');

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw 'Resposta inesperada do servidor';
      }
    } catch (e) {
      rethrow;
    }
  }
}
