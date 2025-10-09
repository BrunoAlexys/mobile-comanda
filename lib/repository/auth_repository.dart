import 'package:mobile_comanda/repository/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data;
      if (responseData == null || responseData is! Map) {
        throw Exception('Resposta da API de login é inválida ou vazia.');
      }

      final accessToken = responseData['accessToken'] as String?;
      final refreshToken = responseData['refreshToken'] as String?;

      if (accessToken != null && refreshToken != null) {
        return {'accessToken': accessToken, 'refreshToken': refreshToken};
      } else {
        throw Exception(
          'Chave "accessToken" ou "refreshToken" não encontrada na resposta da API.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
