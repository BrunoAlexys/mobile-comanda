import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/service/auth_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([AuthRepository, FlutterSecureStorage])
void main() {
  late AuthService authService;
  late MockAuthRepository mockAuthRepository;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStorage = MockFlutterSecureStorage();
    authService = AuthService(mockAuthRepository, mockSecureStorage);
  });

  group('login', () {
    const testEmail = 'teste@email.com';
    const testPassword = 'password123';
    const testToken = 'fake-jwt-token';

    test('should store token and return it on successful login', () async {
      when(
        mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => testToken);
      when(
        mockSecureStorage.write(key: 'auth_token', value: testToken),
      ).thenAnswer((_) async => Future.value());

      final result = await authService.login(testEmail, testPassword);

      expect(result, testToken);
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verify(
        mockSecureStorage.write(key: 'auth_token', value: testToken),
      ).called(1);
    });

    test(
      'should rethrow error and not store token when repository fails',
      () async {
        const errorMessage = 'Credenciais inválidas';
        when(
          mockAuthRepository.login(testEmail, testPassword),
        ).thenThrow(errorMessage);

        expect(
          () => authService.login(testEmail, testPassword),
          throwsA(equals(errorMessage)),
        );

        verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
        verifyNever(
          mockSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        );
      },
    );

    test('should throw an error when secure storage fails to write', () async {
      const storageError = 'Falha ao escrever no armazenamento seguro';
      when(
        mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => testToken);
      when(
        mockSecureStorage.write(key: 'auth_token', value: testToken),
      ).thenThrow(storageError);

      final future = authService.login(testEmail, testPassword);

      await expectLater(future, throwsA(equals(storageError)));

      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verify(
        mockSecureStorage.write(key: 'auth_token', value: testToken),
      ).called(1);
    });
  });
}
