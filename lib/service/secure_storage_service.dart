import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_comanda/enum/biometric_preference.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyEmail = 'biometric_email';
  static const _keyPassword = 'biometric_password';
  static const _keyBiometricPreference = 'biometric_preference';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _storage.write(key: _keyAccessToken, value: accessToken);
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao salvar tokens: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao ler access token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao ler refresh token: $e');
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _keyAccessToken);
      await _storage.delete(key: _keyRefreshToken);
      debugPrint('[SecureStorageService] Tokens limpos com sucesso.');
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao limpar tokens: $e');
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    try {
      await _storage.write(key: _keyEmail, value: email);
      await _storage.write(key: _keyPassword, value: password);
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao salvar credenciais: $e');
    }
  }

  Future<Map<String, String?>> getCredentials() async {
    try {
      final email = await _storage.read(key: _keyEmail);
      final password = await _storage.read(key: _keyPassword);
      return {'email': email, 'password': password};
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao ler credenciais: $e');
      return {'email': null, 'password': null};
    }
  }

  Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: _keyEmail);
      await _storage.delete(key: _keyPassword);
      debugPrint('[SecureStorageService] Credenciais limpas com sucesso.');
    } catch (e) {
      debugPrint('[SecureStorageService] Falha ao limpar credenciais: $e');
    }
  }

  Future<BiometricPreference> getBiometricPreference() async {
    try {
      final value = await _storage.read(key: _keyBiometricPreference);
      if (value == BiometricPreference.enabled.name) {
        return BiometricPreference.enabled;
      } else if (value == BiometricPreference.disabled.name) {
        return BiometricPreference.disabled;
      } else {
        return BiometricPreference.notChoosen;
      }
    } catch (e) {
      debugPrint(
        '[SecureStorageService] Falha ao ler preferência biométrica: $e',
      );
      return BiometricPreference.notChoosen;
    }
  }

  Future<void> setBiometricPreference(BiometricPreference preference) async {
    try {
      await _storage.write(
        key: _keyBiometricPreference,
        value: preference.name,
      );
    } catch (e) {
      debugPrint(
        '[SecureStorageService] Falha ao salvar preferência biométrica: $e',
      );
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _keyBiometricPreference);
      return value == BiometricPreference.enabled.name;
    } catch (e) {
      debugPrint(
        '[SecureStorageService] Falha ao verificar se biometria está ativa: $e',
      );
      return false;
    }
  }
}
