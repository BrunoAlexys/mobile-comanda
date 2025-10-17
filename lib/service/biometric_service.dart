import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService(this._auth);

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        debugPrint(
          '[BiometricService] O dispositivo não pode verificar a biometria.',
        );
        return false;
      }

      final List<BiometricType> availableBiometrics = await _auth
          .getAvailableBiometrics();

      return availableBiometrics.isNotEmpty;
    } catch (e) {
      debugPrint(
        '[BiometricService] Erro ao verificar disponibilidade da biometria: $e',
      );
      return false;
    }
  }

  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Autenticação Biométrica',
            biometricHint: 'Toque no sensor biométrico',
            cancelButton: 'Cancelar',
            biometricNotRecognized:
                'Biometria não reconhecida. Tente novamente.',
            biometricRequiredTitle: 'Biometria necessária',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancelar',
            goToSettingsButton: 'Ajustes',
            goToSettingsDescription: 'Por favor, configure sua biometria.',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint(
        '[BiometricService] Erro de plataforma durante autenticação: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('[BiometricService] Erro inesperado durante autenticação: $e');
      return false;
    }
  }
}
