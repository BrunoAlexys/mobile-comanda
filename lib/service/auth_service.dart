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

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _secureStorage.deleteAll();
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
