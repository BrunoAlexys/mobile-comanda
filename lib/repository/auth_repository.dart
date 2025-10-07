import 'package:mobile_comanda/repository/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<String> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final String token = response.data['token'];
        return token;
      } else {
        throw 'Resposta inesperada do servidor';
      }
    } catch (e) {
      rethrow;
    }
  }
}
