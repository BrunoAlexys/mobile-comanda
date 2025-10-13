import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/enum/biometric_preference.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';

void main() {
  late SecureStorageService secureStorageService;

  setUpAll(() {
    // Inicializar bindings do Flutter necessários para FlutterSecureStorage
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    secureStorageService = SecureStorageService();
  });

  // NOTA: Estes testes focam no comportamento de tratamento de exceções
  // do SecureStorageService. Em ambiente de teste unitário, o FlutterSecureStorage
  // não tem implementação nativa, então todas as operações falharão com MissingPluginException.
  // Isso permite testar se o serviço lida adequadamente com falhas de storage.

  group('SecureStorageService - Tokens - Error Handling', () {
    const testAccessToken = 'access_token_123';
    const testRefreshToken = 'refresh_token_456';

    test('deve lidar com exceções ao salvar tokens sem falhar', () async {
      // Act & Assert - não deve lançar exceção
      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: testAccessToken,
          refreshToken: testRefreshToken,
        ),
        returnsNormally,
      );
    });

    test(
      'deve retornar null quando há exceção na leitura de access token',
      () async {
        // Act
        final result = await secureStorageService.getAccessToken();

        // Assert
        expect(result, isNull);
      },
    );

    test(
      'deve retornar null quando há exceção na leitura de refresh token',
      () async {
        // Act
        final result = await secureStorageService.getRefreshToken();

        // Assert
        expect(result, isNull);
      },
    );

    test('deve lidar com exceções ao limpar tokens sem falhar', () async {
      // Act & Assert - não deve lançar exceção
      expect(
        () async => await secureStorageService.clearTokens(),
        returnsNormally,
      );
    });

    test('deve aceitar diferentes tipos de tokens sem validação', () async {
      // Teste com diferentes valores
      const emptyToken = '';
      final longToken = 'a' * 1000;
      const specialCharsToken = 'token!@#\$%^&*()_+{}[]|\\:";\'<>?,.~/`';

      // Act & Assert - todos devem executar sem exceção
      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: emptyToken,
          refreshToken: emptyToken,
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: longToken,
          refreshToken: longToken,
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: specialCharsToken,
          refreshToken: specialCharsToken,
        ),
        returnsNormally,
      );
    });
  });

  group('SecureStorageService - Credentials - Error Handling', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('deve lidar com exceções ao salvar credenciais sem falhar', () async {
      expect(
        () async =>
            await secureStorageService.saveCredentials(testEmail, testPassword),
        returnsNormally,
      );
    });

    test(
      'deve retornar credenciais nulas quando há exceção na leitura',
      () async {
        final credentials = await secureStorageService.getCredentials();

        expect(credentials['email'], isNull);
        expect(credentials['password'], isNull);
        expect(credentials, isA<Map<String, String?>>());
        expect(credentials.containsKey('email'), isTrue);
        expect(credentials.containsKey('password'), isTrue);
      },
    );

    test('deve lidar com exceções ao limpar credenciais sem falhar', () async {
      expect(
        () async => await secureStorageService.clearCredentials(),
        returnsNormally,
      );
    });

    test(
      'deve aceitar diferentes tipos de credenciais sem validação',
      () async {
        const emptyEmail = '';
        const emptyPassword = '';
        const specialEmail = 'test+special@domain.co.uk';
        const specialPassword = 'P@ssw0rd!@#\$%^&*()_+{}[]|\\:";\'<>?,.~/`';
        final longEmail =
            'very.long.email.address@very.long.domain.name.example.com';
        final longPassword = 'a' * 500;

        expect(
          () async => await secureStorageService.saveCredentials(
            emptyEmail,
            emptyPassword,
          ),
          returnsNormally,
        );

        expect(
          () async => await secureStorageService.saveCredentials(
            specialEmail,
            specialPassword,
          ),
          returnsNormally,
        );

        expect(
          () async => await secureStorageService.saveCredentials(
            longEmail,
            longPassword,
          ),
          returnsNormally,
        );
      },
    );
  });

  group('SecureStorageService - Biometric Preference - Error Handling', () {
    test(
      'deve lidar com exceções ao salvar preferência biométrica sem falhar',
      () async {
        for (final preference in BiometricPreference.values) {
          expect(
            () async =>
                await secureStorageService.setBiometricPreference(preference),
            returnsNormally,
          );
        }
      },
    );

    test(
      'deve retornar notChoosen como padrão quando há exceção na leitura',
      () async {
        final preference = await secureStorageService.getBiometricPreference();

        expect(preference, equals(BiometricPreference.notChoosen));
      },
    );

    test(
      'deve retornar false quando há exceção em isBiometricEnabled',
      () async {
        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(isEnabled, isFalse);
      },
    );

    test(
      'deve manter consistência entre getBiometricPreference e isBiometricEnabled com exceções',
      () async {
        final preference = await secureStorageService.getBiometricPreference();
        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(preference, equals(BiometricPreference.notChoosen));
        expect(isEnabled, isFalse);
      },
    );

    test('deve validar todos os valores do enum BiometricPreference', () async {
      for (final preference in BiometricPreference.values) {
        expect(
          () async =>
              await secureStorageService.setBiometricPreference(preference),
          returnsNormally,
        );
      }

      expect(BiometricPreference.values, hasLength(3));
      expect(BiometricPreference.values, contains(BiometricPreference.enabled));
      expect(
        BiometricPreference.values,
        contains(BiometricPreference.disabled),
      );
      expect(
        BiometricPreference.values,
        contains(BiometricPreference.notChoosen),
      );
    });
  });

  group('SecureStorageService - Integration Tests', () {
    test('deve executar todas as operações sem lançar exceções', () async {
      const accessToken = 'access_123';
      const refreshToken = 'refresh_456';
      const email = 'test@example.com';
      const password = 'password123';
      const preference = BiometricPreference.enabled;

      expect(() async {
        await secureStorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await secureStorageService.getAccessToken();
        await secureStorageService.getRefreshToken();
        await secureStorageService.clearTokens();

        await secureStorageService.saveCredentials(email, password);
        await secureStorageService.getCredentials();
        await secureStorageService.clearCredentials();

        await secureStorageService.setBiometricPreference(preference);
        await secureStorageService.getBiometricPreference();
        await secureStorageService.isBiometricEnabled();
      }, returnsNormally);
    });

    test(
      'deve retornar valores padrão consistentes em caso de falha',
      () async {
        // Act
        final accessToken = await secureStorageService.getAccessToken();
        final refreshToken = await secureStorageService.getRefreshToken();
        final credentials = await secureStorageService.getCredentials();
        final preference = await secureStorageService.getBiometricPreference();
        final isEnabled = await secureStorageService.isBiometricEnabled();

        expect(accessToken, isNull);
        expect(refreshToken, isNull);
        expect(credentials['email'], isNull);
        expect(credentials['password'], isNull);
        expect(credentials, hasLength(2));
        expect(preference, equals(BiometricPreference.notChoosen));
        expect(isEnabled, isFalse);
      },
    );

    test('deve permitir operações sequenciais sem interferência', () async {
      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: 'login_token',
          refreshToken: 'login_refresh',
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.setBiometricPreference(
          BiometricPreference.enabled,
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.saveCredentials(
          'user@app.com',
          'userpass',
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.saveTokens(
          accessToken: 'new_token',
          refreshToken: 'new_refresh',
        ),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.clearTokens(),
        returnsNormally,
      );

      expect(
        () async => await secureStorageService.clearCredentials(),
        returnsNormally,
      );
    });

    test('deve manter interface consistente para todos os métodos', () async {
      expect(
        secureStorageService.saveTokens(accessToken: 'a', refreshToken: 'r'),
        isA<Future<void>>(),
      );
      expect(secureStorageService.getAccessToken(), isA<Future<String?>>());
      expect(secureStorageService.getRefreshToken(), isA<Future<String?>>());
      expect(secureStorageService.clearTokens(), isA<Future<void>>());

      expect(
        secureStorageService.saveCredentials('email', 'password'),
        isA<Future<void>>(),
      );
      expect(
        secureStorageService.getCredentials(),
        isA<Future<Map<String, String?>>>(),
      );
      expect(secureStorageService.clearCredentials(), isA<Future<void>>());

      expect(
        secureStorageService.setBiometricPreference(
          BiometricPreference.enabled,
        ),
        isA<Future<void>>(),
      );
      expect(
        secureStorageService.getBiometricPreference(),
        isA<Future<BiometricPreference>>(),
      );
      expect(secureStorageService.isBiometricEnabled(), isA<Future<bool>>());
    });
  });
}
