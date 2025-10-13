import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/repository/user_repository.dart';
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
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }

    if (_mockedResponses != null && _mockedResponses!.containsKey(path)) {
      return _mockedResponses![path]!;
    }

    throw Exception('No mock response configured for path: $path');
  }

  @override
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    throw UnimplementedError();
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
  late UserRepository userRepository;
  late TestDioClient testDioClient;

  setUp(() {
    testDioClient = TestDioClient();
    userRepository = UserRepository(testDioClient);
  });

  tearDown(() {
    testDioClient.reset();
  });

  group('UserRepository - fetchUser', () {
    const testEmail = 'test@example.com';

    test(
      'deve retornar dados do usuário quando requisição é bem-sucedida',
      () async {
        final expectedUserData = {
          'id': 1,
          'email': testEmail,
          'name': 'Test User',
          'createdAt': '2023-01-01T00:00:00Z',
        };

        final mockResponse = Response(
          data: expectedUserData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$testEmail'),
        );

        testDioClient.mockResponse('/users/$testEmail', mockResponse);

        final result = await userRepository.fetchUser(testEmail);

        expect(result, equals(expectedUserData));
        expect(result['email'], equals(testEmail));
        expect(result['name'], equals('Test User'));
      },
    );

    test('deve lançar exceção quando response data é null', () async {
      final mockResponse = Response(
        data: null,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );

      testDioClient.mockResponse('/users/$testEmail', mockResponse);

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load user data'),
          ),
        ),
      );
    });

    test('deve lançar exceção quando status code não é 200', () async {
      final mockResponse = Response(
        data: {'error': 'User not found'},
        statusCode: 404,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );

      testDioClient.mockResponse('/users/$testEmail', mockResponse);

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load user data'),
          ),
        ),
      );
    });

    test('deve propagar exceção do DioClient', () async {
      const errorMessage = 'Network error occurred';

      testDioClient.mockException(Exception(errorMessage));

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(errorMessage),
          ),
        ),
      );
    });

    test('deve funcionar com diferentes emails válidos', () async {
      const emails = [
        'user1@test.com',
        'admin@company.org',
        'developer@mobile.app',
      ];

      for (final email in emails) {
        final userData = {
          'id': emails.indexOf(email) + 1,
          'email': email,
          'name': 'User ${emails.indexOf(email) + 1}',
        };

        final mockResponse = Response(
          data: userData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$email'),
        );

        testDioClient.mockResponse('/users/$email', mockResponse);

        final result = await userRepository.fetchUser(email);

        expect(result, equals(userData));
        expect(result['email'], equals(email));

        testDioClient.reset();
      }
    });

    test('deve tratar resposta com dados complexos', () async {
      final complexUserData = {
        'id': 1,
        'email': testEmail,
        'name': 'Complex User',
        'profile': {
          'avatar': 'https://example.com/avatar.jpg',
          'bio': 'Software developer',
          'preferences': {'theme': 'dark', 'notifications': true},
        },
        'roles': ['user', 'moderator'],
        'metadata': {'lastLoginAt': '2023-12-01T10:30:00Z', 'loginCount': 150},
      };

      final mockResponse = Response(
        data: complexUserData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );

      testDioClient.mockResponse('/users/$testEmail', mockResponse);

      final result = await userRepository.fetchUser(testEmail);

      expect(result, equals(complexUserData));
      expect(result['profile']['preferences']['theme'], equals('dark'));
      expect(result['roles'], contains('user'));
      expect(result['roles'], contains('moderator'));
      expect(result['metadata']['loginCount'], equals(150));
    });

    test('deve tratar diferentes códigos de erro HTTP', () async {
      final errorCodes = [400, 401, 403, 404, 500, 502, 503];

      for (final statusCode in errorCodes) {
        final mockResponse = Response(
          data: {'error': 'HTTP Error $statusCode'},
          statusCode: statusCode,
          requestOptions: RequestOptions(path: '/users/$testEmail'),
        );

        testDioClient.mockResponse('/users/$testEmail', mockResponse);
        expect(
          () => userRepository.fetchUser(testEmail),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to load user data'),
            ),
          ),
          reason: 'Should throw exception for HTTP $statusCode',
        );

        testDioClient.reset();
      }
    });

    test('deve construir URL corretamente para emails especiais', () async {
      const specialEmails = [
        'user+tag@example.com',
        'user.name@example.com',
        'user_name@example-domain.com',
      ];

      for (final email in specialEmails) {
        final userData = {'id': 1, 'email': email};
        final mockResponse = Response(
          data: userData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$email'),
        );

        testDioClient.mockResponse('/users/$email', mockResponse);

        final result = await userRepository.fetchUser(email);

        expect(result['email'], equals(email));

        testDioClient.reset();
      }
    });

    test('deve tratar status code 200 com data vazio mas válido', () async {
      final emptyUserData = <String, dynamic>{};
      final mockResponse = Response(
        data: emptyUserData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );

      testDioClient.mockResponse('/users/$testEmail', mockResponse);

      final result = await userRepository.fetchUser(testEmail);

      expect(result, equals(emptyUserData));
      expect(result, isA<Map<String, dynamic>>());
    });

    test('deve tratar exceções específicas do Dio', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/users/$testEmail'),
        type: DioExceptionType.connectionTimeout,
      );

      testDioClient.mockException(dioException);

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('UserRepository - Construtor e Dependências', () {
    test('deve criar instância corretamente com DioClient', () {
      final repository = UserRepository(testDioClient);

      expect(repository, isNotNull);
      expect(repository, isA<UserRepository>());
    });

    test('deve usar o DioClient injetado para fazer requisições', () async {
      const email = 'dependency@test.com';
      final mockResponse = Response(
        data: {'id': 1, 'email': email},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/$email'),
      );

      testDioClient.mockResponse('/users/$email', mockResponse);

      final result = await userRepository.fetchUser(email);

      expect(result['email'], equals(email));
    });
  });

  group('UserRepository - Edge Cases', () {
    test('deve tratar email vazio', () async {
      // Arrange
      const emptyEmail = '';
      final mockResponse = Response(
        data: {'message': 'Invalid email'},
        statusCode: 400,
        requestOptions: RequestOptions(path: '/users/$emptyEmail'),
      );

      testDioClient.mockResponse('/users/$emptyEmail', mockResponse);

      expect(
        () => userRepository.fetchUser(emptyEmail),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load user data'),
          ),
        ),
      );
    });

    test('deve tratar resposta com dados de tipo inesperado', () async {
      // Arrange
      const testEmail = 'unusual@test.com';

      testDioClient.mockException(Exception('Invalid response type'));

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid response type'),
          ),
        ),
      );
    });
  });
}
