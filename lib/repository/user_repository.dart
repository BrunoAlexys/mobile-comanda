import 'package:mobile_comanda/repository/dio_client.dart';

class UserRepository {
  final DioClient _dioClient;

  UserRepository(this._dioClient);

  Future<Map<String, dynamic>> fetchUser(String email) async {
    try {
<<<<<<< HEAD
      final response = await _dioClient.get('/users/$email');
=======
      final response = await _dioClient.get('/admin/$email');

>>>>>>> bd2baabcedf73ed8a343c5707b62051ce69f257a
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