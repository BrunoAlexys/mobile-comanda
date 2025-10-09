import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'dio_client_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late DioClient dioClient;
  late BaseOptions baseOptions;
  const testPath = '/test';
  final requestData = {'key': 'value'};

  setUp(() async {
    await dotenv.load(fileName: ".env");
    mockDio = MockDio();
    baseOptions = BaseOptions();
    mockito.when(mockDio.options).thenReturn(baseOptions);
    mockito.when(mockDio.interceptors).thenReturn(Interceptors());
    dioClient = DioClient(mockDio);
  });

  group('Constructor and Configuration', () {
    test('should set Dio options correctly on initialization', () {
      expect(mockDio.options.connectTimeout, const Duration(seconds: 15));
      expect(mockDio.options.receiveTimeout, const Duration(seconds: 15));
      expect(
        mockDio.options.headers['Content-Type'],
        'application/json; charset=UTF-8',
      );
      expect(mockDio.options.headers['Accept'], 'application/json');
    });
  });

  group('Authentication', () {
    test('setAuthToken should add Authorization header correctly', () {
      const token = 'my-secret-token';
      dioClient.setAuthToken(token);
      expect(mockDio.options.headers['Authorization'], 'Bearer $token');
    });

    test('removeAuthToken should remove Authorization header', () {
      dioClient.setAuthToken('any-token');
      dioClient.removeAuthToken();
      expect(mockDio.options.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('GET requests', () {
    test('should return Response on successful GET', () async {
      final fakeResponse = Response(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 200,
        data: {'id': 1},
      );
      mockito.when(mockDio.get(testPath)).thenAnswer((_) async => fakeResponse);

      final result = await dioClient.get(testPath);

      expect(result, fakeResponse);
      mockito.verify(mockDio.get(testPath)).called(1);
    });

    test('should throw formatted error on failed GET', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: testPath),
        type: DioExceptionType.connectionTimeout,
      );
      mockito.when(mockDio.get(testPath)).thenThrow(dioException);

      expect(
        () => dioClient.get(testPath),
        throwsA(equals('Tempo de conexão esgotado. Verifique sua conexão.')),
      );
    });
  });

  group('POST requests', () {
    test('should return Response on successful POST', () async {
      final fakeResponse = Response(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 201,
        data: {'message': 'Created'},
      );
      mockito
          .when(mockDio.post(testPath, data: requestData))
          .thenAnswer((_) async => fakeResponse);

      final result = await dioClient.post(testPath, data: requestData);

      expect(result, fakeResponse);
      mockito.verify(mockDio.post(testPath, data: requestData)).called(1);
    });

    test('should throw formatted error on failed POST', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: testPath),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: testPath),
          statusCode: 400,
        ),
      );
      mockito
          .when(mockDio.post(testPath, data: requestData))
          .thenThrow(dioException);

      expect(
        () => dioClient.post(testPath, data: requestData),
        throwsA(equals('Requisição inválida.')),
      );
    });
  });

  group('PUT requests', () {
    test('should return Response on successful PUT', () async {
      final fakeResponse = Response(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 200,
        data: {'message': 'Updated'},
      );
      mockito
          .when(mockDio.put(testPath, data: requestData))
          .thenAnswer((_) async => fakeResponse);

      final result = await dioClient.put(testPath, data: requestData);

      expect(result, fakeResponse);
      mockito.verify(mockDio.put(testPath, data: requestData)).called(1);
    });

    test('should throw formatted error on failed PUT', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: testPath),
        type: DioExceptionType.unknown,
      );
      mockito
          .when(mockDio.put(testPath, data: requestData))
          .thenThrow(dioException);

      expect(
        () => dioClient.put(testPath, data: requestData),
        throwsA(isA<String>()),
      );
    });
  });

  group('PATCH requests', () {
    test('should return Response on successful PATCH', () async {
      final fakeResponse = Response(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 200,
        data: {'message': 'Patched'},
      );
      mockito
          .when(mockDio.patch(testPath, data: requestData))
          .thenAnswer((_) async => fakeResponse);

      final result = await dioClient.patch(testPath, data: requestData);

      expect(result, fakeResponse);
      mockito.verify(mockDio.patch(testPath, data: requestData)).called(1);
    });

    test('should throw formatted error on failed PATCH', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: testPath),
        type: DioExceptionType.connectionError,
      );
      mockito
          .when(mockDio.patch(testPath, data: requestData))
          .thenThrow(dioException);

      expect(
        () => dioClient.patch(testPath, data: requestData),
        throwsA(equals('Erro de conexão. Verifique sua internet.')),
      );
    });
  });

  group('DELETE requests', () {
    test('should return Response on successful DELETE', () async {
      final fakeResponse = Response(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 204,
      );
      mockito
          .when(mockDio.delete(testPath))
          .thenAnswer((_) async => fakeResponse);

      final result = await dioClient.delete(testPath);

      expect(result, fakeResponse);
      mockito.verify(mockDio.delete(testPath)).called(1);
    });

    test('should throw formatted error on failed DELETE', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: testPath),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: testPath),
          statusCode: 404,
        ),
      );
      mockito.when(mockDio.delete(testPath)).thenThrow(dioException);

      expect(
        () => dioClient.delete(testPath),
        throwsA(equals('O recurso solicitado não foi encontrado.')),
      );
    });
  });

  group('Error Handling (_handleError)', () {
    Future<void> testErrorScenario({
      required DioExceptionType type,
      int? statusCode,
      required String expectedMessage,
    }) async {
      final response = statusCode != null
          ? Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: statusCode,
            )
          : null;

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: type,
        response: response,
      );

      mockito.when(mockDio.get('/')).thenThrow(dioException);

      expect(() => dioClient.get('/'), throwsA(equals(expectedMessage)));
    }

    test('handles connectionTimeout correctly', () async {
      await testErrorScenario(
        type: DioExceptionType.connectionTimeout,
        expectedMessage: 'Tempo de conexão esgotado. Verifique sua conexão.',
      );
    });

    test('handles cancel correctly', () async {
      await testErrorScenario(
        type: DioExceptionType.cancel,
        expectedMessage: 'Requisição cancelada.',
      );
    });

    test('handles connectionError correctly', () async {
      await testErrorScenario(
        type: DioExceptionType.connectionError,
        expectedMessage: 'Erro de conexão. Verifique sua internet.',
      );
    });

    group('Bad Response Errors', () {
      test('handles 400 Bad Request', () async {
        await testErrorScenario(
          type: DioExceptionType.badResponse,
          statusCode: 400,
          expectedMessage: 'Requisição inválida.',
        );
      });

      test('handles 401 Unauthorized', () async {
        await testErrorScenario(
          type: DioExceptionType.badResponse,
          statusCode: 401,
          expectedMessage: 'E-mail ou senha inválidos. Faça login novamente.',
        );
      });

      test('handles 404 Not Found', () async {
        await testErrorScenario(
          type: DioExceptionType.badResponse,
          statusCode: 404,
          expectedMessage: 'O recurso solicitado não foi encontrado.',
        );
      });

      test('handles 500 Internal Server Error', () async {
        await testErrorScenario(
          type: DioExceptionType.badResponse,
          statusCode: 500,
          expectedMessage: 'Erro interno no servidor.',
        );
      });

      test('handles other bad response status codes', () async {
        await testErrorScenario(
          type: DioExceptionType.badResponse,
          statusCode: 503,
          expectedMessage: 'Erro no servidor (código 503).',
        );
      });
    });

    test('should throw a generic error string on other exceptions', () async {
      mockito
          .when(mockDio.get('/test'))
          .thenThrow(Exception('Some random error'));

      expect(
        () => dioClient.get('/test'),
        throwsA(
          equals('Ocorreu um erro inesperado: Exception: Some random error'),
        ),
      );
    });
  });
}
