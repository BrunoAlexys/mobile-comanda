import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../lib/service/biometric_service.dart';

import 'biometric_service_test.mocks.dart';

@GenerateMocks([LocalAuthentication])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BiometricService', () {
    late BiometricService biometricService;
    late MockLocalAuthentication mockLocalAuth;

    setUp(() {
      mockLocalAuth = MockLocalAuthentication();
      biometricService = BiometricService(mockLocalAuth);
    });

    group('isBiometricAvailable', () {
      test('deve retornar true quando biometria estiver disponível', () async {
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(
          mockLocalAuth.getAvailableBiometrics(),
        ).thenAnswer((_) async => [BiometricType.fingerprint]);

        final result = await biometricService.isBiometricAvailable();

        expect(result, isTrue);
        verify(mockLocalAuth.canCheckBiometrics).called(1);
        verify(mockLocalAuth.getAvailableBiometrics()).called(1);
      });

      test(
        'deve retornar false quando dispositivo não pode verificar biometria',
        () async {
          when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => false);

          final result = await biometricService.isBiometricAvailable();

          expect(result, isFalse);
          verify(mockLocalAuth.canCheckBiometrics).called(1);
          verifyNever(mockLocalAuth.getAvailableBiometrics());
        },
      );

      test(
        'deve retornar false quando lista de biometrias está vazia',
        () async {
          when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
          when(
            mockLocalAuth.getAvailableBiometrics(),
          ).thenAnswer((_) async => <BiometricType>[]);

          final result = await biometricService.isBiometricAvailable();

          expect(result, isFalse);
          verify(mockLocalAuth.canCheckBiometrics).called(1);
          verify(mockLocalAuth.getAvailableBiometrics()).called(1);
        },
      );

      test(
        'deve retornar true quando múltiplas biometrias estão disponíveis',
        () async {
          when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
          when(mockLocalAuth.getAvailableBiometrics()).thenAnswer(
            (_) async => [BiometricType.fingerprint, BiometricType.face],
          );

          final result = await biometricService.isBiometricAvailable();

          expect(result, isTrue);
          verify(mockLocalAuth.canCheckBiometrics).called(1);
          verify(mockLocalAuth.getAvailableBiometrics()).called(1);
        },
      );

      test('deve retornar false e logar erro quando exceção ocorre', () async {
        when(
          mockLocalAuth.canCheckBiometrics,
        ).thenThrow(Exception('Erro de teste'));

        final result = await biometricService.isBiometricAvailable();

        expect(result, isFalse);
        verify(mockLocalAuth.canCheckBiometrics).called(1);
      });

      test('deve retornar false quando getAvailableBiometrics falha', () async {
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(
          mockLocalAuth.getAvailableBiometrics(),
        ).thenThrow(Exception('Erro ao obter biometrias'));

        final result = await biometricService.isBiometricAvailable();

        expect(result, isFalse);
        verify(mockLocalAuth.canCheckBiometrics).called(1);
        verify(mockLocalAuth.getAvailableBiometrics()).called(1);
      });
    });

    group('authenticate', () {
      const String testReason = 'Teste de autenticação';

      test('deve retornar true quando autenticação é bem-sucedida', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => true);

        final result = await biometricService.authenticate(
          localizedReason: testReason,
        );

        expect(result, isTrue);
        verify(
          mockLocalAuth.authenticate(
            localizedReason: testReason,
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test('deve retornar false quando autenticação falha', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => false);

        final result = await biometricService.authenticate(
          localizedReason: testReason,
        );

        expect(result, isFalse);
        verify(
          mockLocalAuth.authenticate(
            localizedReason: testReason,
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test('deve retornar false quando PlatformException é lançada', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          PlatformException(
            code: 'UserCancel',
            message: 'User canceled authentication',
          ),
        );

        final result = await biometricService.authenticate(
          localizedReason: testReason,
        );

        expect(result, isFalse);
        verify(
          mockLocalAuth.authenticate(
            localizedReason: testReason,
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test('deve retornar false quando exceção genérica é lançada', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenThrow(Exception('Erro inesperado'));

        final result = await biometricService.authenticate(
          localizedReason: testReason,
        );

        expect(result, isFalse);
        verify(
          mockLocalAuth.authenticate(
            localizedReason: testReason,
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test('deve usar configurações corretas de autenticação', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => true);

        await biometricService.authenticate(localizedReason: testReason);

        final captured = verify(
          mockLocalAuth.authenticate(
            localizedReason: captureAnyNamed('localizedReason'),
            authMessages: captureAnyNamed('authMessages'),
            options: captureAnyNamed('options'),
          ),
        ).captured;

        expect(captured[0], equals(testReason));
        expect(captured[1], isA<List<Object>>());
        expect(captured[2], isA<Object>());
      });

      test('deve aceitar diferentes razões de autenticação', () async {
        const reasons = [
          'Acesse sua conta',
          'Confirme o pagamento',
          'Desbloqueie o app',
          'Autentique-se para continuar',
        ];

        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => true);

        for (final reason in reasons) {
          final result = await biometricService.authenticate(
            localizedReason: reason,
          );
          expect(result, isTrue);
        }

        verify(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(reasons.length);
      });
    });

    group('Integration Tests', () {
      test('deve executar verificação e autenticação em sequência', () async {
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(
          mockLocalAuth.getAvailableBiometrics(),
        ).thenAnswer((_) async => [BiometricType.fingerprint]);
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => true);

        final isAvailable = await biometricService.isBiometricAvailable();
        final authResult = await biometricService.authenticate(
          localizedReason: 'Teste integração',
        );

        expect(isAvailable, isTrue);
        expect(authResult, isTrue);
        verify(mockLocalAuth.canCheckBiometrics).called(1);
        verify(mockLocalAuth.getAvailableBiometrics()).called(1);
        verify(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test(
        'deve manter consistência quando disponibilidade falha mas autenticação é chamada',
        () async {
          when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => false);
          when(
            mockLocalAuth.authenticate(
              localizedReason: anyNamed('localizedReason'),
              authMessages: anyNamed('authMessages'),
              options: anyNamed('options'),
            ),
          ).thenAnswer((_) async => false);

          final isAvailable = await biometricService.isBiometricAvailable();
          final authResult = await biometricService.authenticate(
            localizedReason: 'Teste consistência',
          );

          expect(isAvailable, isFalse);
          expect(authResult, isFalse);
        },
      );

      test(
        'deve lidar com múltiplas chamadas simultâneas graciosamente',
        () async {
          when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
          when(
            mockLocalAuth.getAvailableBiometrics(),
          ).thenAnswer((_) async => [BiometricType.face]);

          final futures = List.generate(
            3,
            (_) => biometricService.isBiometricAvailable(),
          );
          final results = await Future.wait(futures);

          expect(results, everyElement(isTrue));
          verify(mockLocalAuth.canCheckBiometrics).called(3);
          verify(mockLocalAuth.getAvailableBiometrics()).called(3);
        },
      );

      test('deve manter estado consistente após falhas', () async {
        when(
          mockLocalAuth.canCheckBiometrics,
        ).thenThrow(Exception('Primeira falha'));

        final firstResult = await biometricService.isBiometricAvailable();

        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(
          mockLocalAuth.getAvailableBiometrics(),
        ).thenAnswer((_) async => [BiometricType.fingerprint]);

        final secondResult = await biometricService.isBiometricAvailable();

        expect(firstResult, isFalse);
        expect(secondResult, isTrue);
      });
    });

    group('Error Handling', () {
      test('deve tratar diferentes códigos de PlatformException', () async {
        final platformExceptions = [
          PlatformException(code: 'UserCancel', message: 'Cancelado'),
          PlatformException(code: 'NotAvailable', message: 'Não disponível'),
          PlatformException(code: 'NotEnrolled', message: 'Não cadastrado'),
          PlatformException(code: 'LockedOut', message: 'Bloqueado'),
        ];

        for (final exception in platformExceptions) {
          when(
            mockLocalAuth.authenticate(
              localizedReason: anyNamed('localizedReason'),
              authMessages: anyNamed('authMessages'),
              options: anyNamed('options'),
            ),
          ).thenThrow(exception);

          final result = await biometricService.authenticate(
            localizedReason: 'Teste ${exception.code}',
          );

          expect(result, isFalse);
        }
      });

      test('deve manter robustez com entradas extremas', () async {
        when(
          mockLocalAuth.authenticate(
            localizedReason: anyNamed('localizedReason'),
            authMessages: anyNamed('authMessages'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => true);

        final extremeInputs = [
          '',
          ' ',
          'a' * 1000,
          'Texto com\nquebras\tde linha',
          '🔐 Emojis são permitidos 👆',
        ];

        for (final input in extremeInputs) {
          final result = await biometricService.authenticate(
            localizedReason: input,
          );
          expect(result, isTrue);
        }
      });
    });
  });
}
