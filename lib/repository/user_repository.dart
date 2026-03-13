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
        throw Exception('Erro ao carregar dados do usuário');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(int userId, String currentPassword, String newPassword) async {
    try {
      await _dioClient.patch(
        '/api/users/1/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}