import 'package:mobile_comanda/repository/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<Map<String, dynamic>> fetchUser(String email) async {
    return await _userRepository.fetchUser(email);
  }

  Future<void> changeUserPassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      throw Exception('A nova senha e a confirmação não coincidem.');
    }

    if (newPassword.length < 8) {
      throw Exception('A senha deve conter no mínimo 8 caracteres.');
    }

    await _userRepository.updatePassword(userId, currentPassword, newPassword);
  }
}