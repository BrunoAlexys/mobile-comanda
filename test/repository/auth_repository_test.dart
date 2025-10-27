import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/repository/dio_client.dart';

class TestDioClient implements DioClient {
  Map<String, Response>? _mockedResponses;
  Exception? _exceptionToThrow;

  void mockResponse(String path, Response response) {
    _mockedResponses ??= {};
    _mockedResponses![path] = response;
  }

  void mockException(Exception exception) {
    _exceptionToThrow = exception;
  }

  void reset() {
    _mockedResponses = null;
    _exceptionToThrow = null;
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }

    if (_mockedResponses != null && _mockedResponses!.containsKey(path)) {
      return _mockedResponses![path]!;
    }

    throw Exception('No mock response configured for path: $path');
  }

  @override
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    throw UnimplementedError();
  }

  @override
  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    throw UnimplementedError();
  }

  @override
  void setAuthToken(String token) {}

  @override
  void removeAuthToken() {}
}

void main() {
  late AuthRepository authRepository;
  late TestDioClient testDioClient;

  setUp(() {
    testDioClient = TestDioClient();
    authRepository = AuthRepository(testDioClient);
  });

  tearDown(() {
    testDioClient.reset();
  });

  group('AuthRepository - login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('deve retornar tokens quando login é bem-sucedido', () async {
      const expectedAccessToken = 'access_token_123';
      const expectedRefreshToken = 'refresh_token_456';

      final expectedResponseData = {
        'accessToken': expectedAccessToken,
        'refreshToken': expectedRefreshToken,
      };

      final mockResponse = Response(
        data: expectedResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      testDioClient.mockResponse('/auth/login', mockResponse);

      final result = await authRepository.login(testEmail, testPassword);

      expect(result, isA<Map<String, String>>());
      expect(result['accessToken'], equals(expectedAccessToken));
      expect(result['refreshToken'], equals(expectedRefreshToken));
    });

    test('deve lançar exceção quando resposta da API é nula', () async {
      final mockResponse = Response(
        data: null,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      testDioClient.mockResponse('/auth/login', mockResponse);

      expect(
        () async => await authRepository.login(testEmail, testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Resposta da API de login é inválida ou vazia'),
          ),
        ),
      );
    });

    test('deve lançar exceção quando resposta da API não é um Map', () async {
      final mockResponse = Response(
        data: 'invalid response',
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      testDioClient.mockResponse('/auth/login', mockResponse);

      expect(
        () async => await authRepository.login(testEmail, testPassword),
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
      'deve lançar exceção quando accessToken não está presente na resposta',
      () async {
        final expectedResponseData = {
          'refreshToken': 'refresh_token_456',
          // accessToken ausente
        };

        final mockResponse = Response(
          data: expectedResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        testDioClient.mockResponse('/auth/login', mockResponse);

        expect(
          () async => await authRepository.login(testEmail, testPassword),
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

    test(
      'deve lançar exceção quando refreshToken não está presente na resposta',
      () async {
        final expectedResponseData = {'accessToken': 'access_token_123'};

        final mockResponse = Response(
          data: expectedResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        testDioClient.mockResponse('/auth/login', mockResponse);

        expect(
          () async => await authRepository.login(testEmail, testPassword),
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

    test('deve lançar exceção quando accessToken é null', () async {
      final expectedResponseData = {
        'accessToken': null,
        'refreshToken': 'refresh_token_456',
      };

      final mockResponse = Response(
        data: expectedResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      testDioClient.mockResponse('/auth/login', mockResponse);

      expect(
        () async => await authRepository.login(testEmail, testPassword),
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
    });

    test('deve lançar exceção quando refreshToken é null', () async {
      final expectedResponseData = {
        'accessToken': 'access_token_123',
        'refreshToken': null,
      };

      final mockResponse = Response(
        data: expectedResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/auth/login'),
      );

      testDioClient.mockResponse('/auth/login', mockResponse);

      expect(
        () async => await authRepository.login(testEmail, testPassword),
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
    });

    test('deve propagar exceção quando DioClient lança exceção', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );

      testDioClient.mockException(dioException);

      expect(
        () async => await authRepository.login(testEmail, testPassword),
        throwsA(isA<DioException>()),
      );
    });

    test(
      'deve propagar exceção genérica quando DioClient lança Exception',
      () async {
        final genericException = Exception('Network error');
        testDioClient.mockException(genericException);

        expect(
          () async => await authRepository.login(testEmail, testPassword),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'deve tratar resposta com tokens válidos mas de tipos diferentes',
      () async {
        const expectedAccessToken = 'access_token_123';
        const expectedRefreshToken = 'refresh_token_456';

        final expectedResponseData = {
          'accessToken': expectedAccessToken,
          'refreshToken': expectedRefreshToken,
          'extraField': 'should be ignored',
          'userId': 123,
        };

        final mockResponse = Response(
          data: expectedResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        testDioClient.mockResponse('/auth/login', mockResponse);

        final result = await authRepository.login(testEmail, testPassword);

        expect(result, isA<Map<String, String>>());
        expect(result['accessToken'], equals(expectedAccessToken));
        expect(result['refreshToken'], equals(expectedRefreshToken));
        expect(result.length, equals(2)); // Apenas os tokens esperados
      },
    );
  });
}
