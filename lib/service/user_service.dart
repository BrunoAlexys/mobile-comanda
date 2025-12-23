import 'package:flutter/material.dart';
import 'package:mobile_comanda/repository/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<Map<String, dynamic>> fetchUser(String email) async {
    try {
      debugPrint('[UserService] Buscando dados do usuário para: $email');
      final userData = await _userRepository.fetchUser(email);
      debugPrint('[UserService] Dados do usuário buscados com sucesso.');
      return userData;
    } catch (e) {
      debugPrint('[UserService] Falha ao buscar dados do usuário: $e');
      rethrow;
    }
  }

  Future<void> changeUserPassword({
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

    await _userRepository.updatePassword(currentPassword, newPassword);
  }
}
