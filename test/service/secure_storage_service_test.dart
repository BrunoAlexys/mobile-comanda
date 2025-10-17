import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/enum/biometric_preference.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FlutterSecureStorage])
import 'secure_storage_service_test.mocks.dart';

void main() {
  late SecureStorageService secureStorageService;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    secureStorageService = SecureStorageService(mockFlutterSecureStorage);
  });

  group('SecureStorageService - Tokens', () {
    const testAccessToken = 'access_token_123';
    const testRefreshToken = 'refresh_token_456';

    test('deve salvar e retornar tokens com sucesso', () async {
      when(
        mockFlutterSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});

      when(
        mockFlutterSecureStorage.read(key: 'access_token'),
      ).thenAnswer((_) async => testAccessToken);
      when(
        mockFlutterSecureStorage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => testRefreshToken);

      await secureStorageService.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      );
      final accessToken = await secureStorageService.getAccessToken();
      final refreshToken = await secureStorageService.getRefreshToken();

      expect(accessToken, testAccessToken);
      expect(refreshToken, testRefreshToken);
      verify(
        mockFlutterSecureStorage.write(
          key: 'access_token',
          value: testAccessToken,
        ),
      ).called(1);
      verify(
        mockFlutterSecureStorage.write(
          key: 'refresh_token',
          value: testRefreshToken,
        ),
      ).called(1);
    });

    test(
      'deve retornar null quando há exceção na leitura de access token',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'access_token'),
        ).thenThrow(Exception('Storage error'));

        final result = await secureStorageService.getAccessToken();

        expect(result, isNull);
      },
    );

    test(
      'deve retornar null quando há exceção na leitura de refresh token',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'refresh_token'),
        ).thenThrow(Exception('Storage error'));

        final result = await secureStorageService.getRefreshToken();

        expect(result, isNull);
      },
    );

    test('deve executar clearTokens mesmo com exceções', () async {
      // Configura para lançar exceção em ambas as chamadas
      when(
        mockFlutterSecureStorage.delete(key: 'access_token'),
      ).thenThrow(Exception('Storage error'));
      when(
        mockFlutterSecureStorage.delete(key: 'refresh_token'),
      ).thenThrow(Exception('Storage error'));

      // Deve executar sem lançar exceção
      await secureStorageService.clearTokens();
    });

    test('deve executar clearTokens quando apenas access_token falha', () async {
      // Configura access_token para lançar exceção e refresh_token para funcionar
      when(
        mockFlutterSecureStorage.delete(key: 'access_token'),
      ).thenThrow(Exception('Storage error'));
      when(
        mockFlutterSecureStorage.delete(key: 'refresh_token'),
      ).thenAnswer((_) async {});

      // Deve executar sem lançar exceção
      await secureStorageService.clearTokens();
    });
  });

  group('SecureStorageService - Credentials', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('deve salvar e retornar credenciais com sucesso', () async {
      when(
        mockFlutterSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});

      when(
        mockFlutterSecureStorage.read(key: 'biometric_email'),
      ).thenAnswer((_) async => testEmail);
      when(
        mockFlutterSecureStorage.read(key: 'biometric_password'),
      ).thenAnswer((_) async => testPassword);

      await secureStorageService.saveCredentials(testEmail, testPassword);
      final result = await secureStorageService.getCredentials();

      expect(result['email'], testEmail);
      expect(result['password'], testPassword);
      verify(
        mockFlutterSecureStorage.write(
          key: 'biometric_email',
          value: testEmail,
        ),
      ).called(1);
      verify(
        mockFlutterSecureStorage.write(
          key: 'biometric_password',
          value: testPassword,
        ),
      ).called(1);
    });

    test(
      'deve retornar credenciais nulas quando há exceção na leitura',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'biometric_email'),
        ).thenThrow(Exception('Storage error'));
        when(
          mockFlutterSecureStorage.read(key: 'biometric_password'),
        ).thenThrow(Exception('Storage error'));

        final credentials = await secureStorageService.getCredentials();

        expect(credentials['email'], isNull);
        expect(credentials['password'], isNull);
      },
    );
  });

  group('SecureStorageService - Biometric Preference', () {
    test(
      'deve salvar e retornar a preferência biométrica com sucesso',
      () async {
        when(
          mockFlutterSecureStorage.write(
            key: 'biometric_preference',
            value: BiometricPreference.enabled.name,
          ),
        ).thenAnswer((_) async {});

        when(
          mockFlutterSecureStorage.read(key: 'biometric_preference'),
        ).thenAnswer((_) async => BiometricPreference.enabled.name);

        await secureStorageService.setBiometricPreference(
          BiometricPreference.enabled,
        );
        final result = await secureStorageService.getBiometricPreference();

        expect(result, BiometricPreference.enabled);
        verify(
          mockFlutterSecureStorage.write(
            key: 'biometric_preference',
            value: BiometricPreference.enabled.name,
          ),
        ).called(1);
      },
    );

    test('deve retornar notChoosen quando valor salvo é inválido', () async {
      when(
        mockFlutterSecureStorage.read(key: 'biometric_preference'),
      ).thenAnswer((_) async => 'invalid_value');

      final result = await secureStorageService.getBiometricPreference();

      expect(result, BiometricPreference.notChoosen);
    });

    test(
      'deve retornar notChoosen como padrão quando há exceção na leitura',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'biometric_preference'),
        ).thenThrow(Exception('Storage error'));

        final preference = await secureStorageService.getBiometricPreference();

        expect(preference, BiometricPreference.notChoosen);
      },
    );

    test(
      'isBiometricEnabled deve retornar true quando a preferência é enabled',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'biometric_preference'),
        ).thenAnswer((_) async => BiometricPreference.enabled.name);

        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(isEnabled, isTrue);
      },
    );

    test(
      'isBiometricEnabled deve retornar false quando a preferência não é enabled',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'biometric_preference'),
        ).thenAnswer((_) async => BiometricPreference.disabled.name);

        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(isEnabled, isFalse);
      },
    );

    test(
      'deve retornar false quando há exceção em isBiometricEnabled',
      () async {
        when(
          mockFlutterSecureStorage.read(key: 'biometric_preference'),
        ).thenThrow(Exception('Storage error'));

        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(isEnabled, isFalse);
      },
    );
  });
}
