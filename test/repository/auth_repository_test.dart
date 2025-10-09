import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late AuthRepository authRepository;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    authRepository = AuthRepository(mockDioClient);
  });

  group('login', () {
    const testEmail = 'teste@email.com';
    const testPassword = 'password123';
    const testAccessToken = 'fake-access-token';
    const testRefreshToken = 'fake-refresh-token';
    final loginData = {'email': testEmail, 'password': testPassword};

    test('should return tokens map when login is successful', () async {
      final fakeResponse = Response(
        statusCode: 200,
        data: {
          'accessToken': testAccessToken,
          'refreshToken': testRefreshToken,
        },
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      when(
        mockDioClient.post('/auth/login', data: loginData),
      ).thenAnswer((_) async => fakeResponse);

      final result = await authRepository.login(testEmail, testPassword);

      expect(result, {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
      });
      verify(mockDioClient.post('/auth/login', data: loginData)).called(1);
    });

    test('should rethrow error when DioClient throws an exception', () async {
      const errorMessage = 'Usuário ou senha inválidos';
      when(
        mockDioClient.post('/auth/login', data: loginData),
      ).thenThrow(errorMessage);

      expect(
        () => authRepository.login(testEmail, testPassword),
        throwsA(equals(errorMessage)),
      );

      verify(mockDioClient.post('/auth/login', data: loginData)).called(1);
    });

    test('should throw an exception for non-200 status code', () async {
      final fakeResponse = Response(
        statusCode: 401,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      when(
        mockDioClient.post('/auth/login', data: loginData),
      ).thenAnswer((_) async => fakeResponse);

      expect(
        () => authRepository.login(testEmail, testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Resposta da API de login é inválida ou vazia'),
          ),
        ),
      );
    });

    test(
      'should throw an exception for 200 status code with null data',
      () async {
        final fakeResponse = Response(
          statusCode: 200,
          data: null,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(
          mockDioClient.post('/auth/login', data: loginData),
        ).thenAnswer((_) async => fakeResponse);

        expect(
          () => authRepository.login(testEmail, testPassword),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Resposta da API de login é inválida ou vazia'),
            ),
          ),
        );
      },
    );

    test(
      'should throw an error if response data does not contain required tokens',
      () async {
        final fakeResponse = Response(
          statusCode: 200,
          data: {
            'message': 'Success',
          }, // Sem as chaves 'accessToken' e 'refreshToken'
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(
          mockDioClient.post('/auth/login', data: loginData),
        ).thenAnswer((_) async => fakeResponse);

        expect(
          () => authRepository.login(testEmail, testPassword),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains(
                'Chave "accessToken" ou "refreshToken" não encontrada na resposta da API',
              ),
            ),
          ),
        );
      },
    );
  });
}
