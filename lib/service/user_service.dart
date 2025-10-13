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
}
