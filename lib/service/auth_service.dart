import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  AuthService(this._authRepository, this._secureStorage);

  Future<String> login(String email, String password) async {
    try {
      final token = await _authRepository.login(email, password);
      await _secureStorage.write(key: 'auth_token', value: token);
      return token;
    } catch (e) {
      rethrow;
    }
  }
}
