import 'package:flutter/cupertino.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorageService;
  final GlobalKey<NavigatorState> _navigatorKey;

  AuthService(
    this._authRepository,
    this._secureStorageService,
    this._navigatorKey,
  );

  Future<void> login(String email, String password) async {
    try {
      debugPrint('[AuthService] Iniciando tentativa de login para: $email');
      await _secureStorageService.clearTokens();

      final tokens = await _authRepository.login(email, password);
      final accessToken = tokens['accessToken'];
      final refreshToken = tokens['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await _secureStorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        debugPrint('[AuthService] Login bem-sucedido e tokens salvos.');
      } else {
        throw Exception(
          'Tokens de acesso ou atualização nulos recebidos do repositório.',
        );
      }
    } catch (e) {
      debugPrint('[AuthService] Falha no processo de login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      debugPrint('[AuthService] Iniciando processo de logout.');
      await _secureStorageService.clearTokens();
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (Route<dynamic> route) => false,
      );
      debugPrint(
        '[AuthService] Logout concluído. Usuário redirecionado para a tela de login.',
      );
    } catch (e) {
      debugPrint('[AuthService] Falha ao executar logout: $e');
    }
  }
}
