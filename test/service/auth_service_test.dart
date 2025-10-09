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
    const testAccessToken = 'fake-access-token';
    const testRefreshToken = 'fake-refresh-token';
    final testTokens = {
      'accessToken': testAccessToken,
      'refreshToken': testRefreshToken,
    };

    test('should save tokens on successful login', () async {
      when(
        mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => testTokens);
      when(
        mockSecureStorage.write(key: 'access_token', value: testAccessToken),
      ).thenAnswer((_) async => Future.value());
      when(
        mockSecureStorage.write(key: 'refresh_token', value: testRefreshToken),
      ).thenAnswer((_) async => Future.value());

      await authService.login(testEmail, testPassword);

      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verify(
        mockSecureStorage.write(key: 'access_token', value: testAccessToken),
      ).called(1);
      verify(
        mockSecureStorage.write(key: 'refresh_token', value: testRefreshToken),
      ).called(1);
    });

    test(
      'should rethrow error and not save tokens when repository fails',
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
      ).thenAnswer((_) async => testTokens);
      when(
        mockSecureStorage.write(key: 'access_token', value: testAccessToken),
      ).thenThrow(storageError);

      final future = authService.login(testEmail, testPassword);

      await expectLater(future, throwsA(equals(storageError)));

      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verify(
        mockSecureStorage.write(key: 'access_token', value: testAccessToken),
      ).called(1);
      verifyNever(
        mockSecureStorage.write(key: 'refresh_token', value: testRefreshToken),
      );
    });
  });

  group('saveTokens', () {
    const testAccessToken = 'access-token';
    const testRefreshToken = 'refresh-token';
    test(
      'should write both access and refresh tokens to secure storage',
      () async {
        when(
          mockSecureStorage.write(key: 'access_token', value: testAccessToken),
        ).thenAnswer((_) async {});
        when(
          mockSecureStorage.write(
            key: 'refresh_token',
            value: testRefreshToken,
          ),
        ).thenAnswer((_) async {});

        await authService.saveTokens(
          accessToken: testAccessToken,
          refreshToken: testRefreshToken,
        );

        verify(
          mockSecureStorage.write(key: 'access_token', value: testAccessToken),
        ).called(1);
        verify(
          mockSecureStorage.write(
            key: 'refresh_token',
            value: testRefreshToken,
          ),
        ).called(1);
      },
    );
  });

  group('getAccessToken', () {
    test('should return the access token from secure storage', () async {
      const token = 'my-access-token';
      when(
        mockSecureStorage.read(key: 'access_token'),
      ).thenAnswer((_) async => token);

      final result = await authService.getAccessToken();

      expect(result, token);
      verify(mockSecureStorage.read(key: 'access_token')).called(1);
    });
  });

  group('getRefreshToken', () {
    test('should return the refresh token from secure storage', () async {
      const token = 'my-refresh-token';
      when(
        mockSecureStorage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => token);

      final result = await authService.getRefreshToken();

      expect(result, token);
      verify(mockSecureStorage.read(key: 'refresh_token')).called(1);
    });
  });

  group('clearTokens', () {
    test('should call deleteAll on secure storage', () async {
      when(mockSecureStorage.deleteAll()).thenAnswer((_) async {});

      await authService.clearTokens();

      verify(mockSecureStorage.deleteAll()).called(1);
    });
  });

  group('logout', () {
    test('should delete auth_token from secure storage', () async {
      when(
        mockSecureStorage.delete(key: 'auth_token'),
      ).thenAnswer((_) async {});

      await authService.logout();

      verify(mockSecureStorage.delete(key: 'auth_token')).called(1);
    });
  });
}
