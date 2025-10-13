import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class TestDioClient {
  final Dio _dio;

  TestDioClient(this._dio) {
    _dio
      ..options.baseUrl = 'https://test-api.com'
      ..options.connectTimeout = const Duration(seconds: 20)
      ..options.receiveTimeout = const Duration(seconds: 20)
      ..options.sendTimeout = const Duration(seconds: 20)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.post(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.put(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }

  Exception _handleError(DioException error) {
    String errorMessage;
    switch (error.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Requisição cancelada.';
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorMessage = 'Tempo de conexão esgotado. Verifique sua conexão.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            errorMessage = 'Requisição inválida.';
            break;
          case 401:
            errorMessage = 'E-mail ou senha inválidos. Faça login novamente.';
            break;
          case 403:
            errorMessage = 'Acesso negado.';
            break;
          case 404:
            errorMessage = 'O recurso solicitado não foi encontrado.';
            break;
          case 500:
            errorMessage = 'Erro interno no servidor.';
            break;
          default:
            errorMessage = 'Erro no servidor (código $statusCode).';
        }
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Erro de conexão. Verifique sua internet.';
        break;
      default:
        errorMessage = 'Ocorreu um erro inesperado.';
        break;
    }
    return Exception(errorMessage);
  }
}

void main() {
  late TestDioClient dioClient;
  late Dio dio;

  setUp(() {
    dio = Dio();
    dioClient = TestDioClient(dio);
  });

  group('DioClientTest - Configuração Inicial', () {
    test('deve criar instância do DioClientTest corretamente', () {
      final client = TestDioClient(dio);

      expect(client, isNotNull);
      expect(client, isA<TestDioClient>());
    });

    test('deve configurar a baseUrl corretamente', () {
      TestDioClient(dio);

      expect(dio.options.baseUrl, equals('https://test-api.com'));
    });

    test('deve configurar timeouts corretamente', () {
      TestDioClient(dio);

      expect(dio.options.connectTimeout, equals(const Duration(seconds: 20)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 20)));
      expect(dio.options.sendTimeout, equals(const Duration(seconds: 20)));
    });

    test('deve configurar headers padrão corretamente', () {
      TestDioClient(dio);

      expect(
        dio.options.headers['Content-Type'],
        equals('application/json; charset=UTF-8'),
      );
      expect(dio.options.headers['Accept'], equals('application/json'));
    });

    test('deve manter configurações do Dio', () {
      TestDioClient(dio);

      expect(dio.options.baseUrl, isNotEmpty);
      expect(dio.options.headers, isNotEmpty);
    });
  });

  group('DioClientTest - Gerenciamento de Token', () {
    test('deve definir token de autorização corretamente', () {
      const token = 'test-token-123';

      dioClient.setAuthToken(token);

      expect(dio.options.headers['Authorization'], 'Bearer $token');
    });

    test('deve remover token de autorização corretamente', () {
      const token = 'test-token-123';
      dioClient.setAuthToken(token);
      expect(dio.options.headers['Authorization'], 'Bearer $token');

      dioClient.removeAuthToken();

      expect(dio.options.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('DioClientTest - Métodos HTTP', () {
    test(
      'deve executar GET e lançar exceção quando servidor não encontrado',
      () async {
        const path = '/test-endpoint-inexistente';

        expect(() => dioClient.get(path), throwsA(isA<Exception>()));
      },
    );

    test(
      'deve executar POST e lançar exceção quando servidor não encontrado',
      () async {
        const path = '/test-endpoint-inexistente';
        final data = {'name': 'Test'};

        expect(
          () => dioClient.post(path, data: data),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'deve executar PUT e lançar exceção quando servidor não encontrado',
      () async {
        const path = '/test-endpoint-inexistente';
        final data = {'name': 'Updated Test'};

        expect(
          () => dioClient.put(path, data: data),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'deve executar PATCH e lançar exceção quando servidor não encontrado',
      () async {
        const path = '/test-endpoint-inexistente';
        final data = {'status': 'active'};

        expect(
          () => dioClient.patch(path, data: data),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'deve executar DELETE e lançar exceção quando servidor não encontrado',
      () async {
        const path = '/test-endpoint-inexistente';

        expect(() => dioClient.delete(path), throwsA(isA<Exception>()));
      },
    );
  });

  group('DioClientTest - Integração', () {
    test('deve manter configurações após múltiplas operações', () {
      const token1 = 'first-token';
      const token2 = 'second-token';

      dioClient.setAuthToken(token1);
      expect(dio.options.headers['Authorization'], 'Bearer $token1');

      dioClient.setAuthToken(token2);
      expect(dio.options.headers['Authorization'], 'Bearer $token2');

      dioClient.removeAuthToken();
      expect(dio.options.headers.containsKey('Authorization'), isFalse);

      expect(dio.options.baseUrl, equals('https://test-api.com'));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 20)));
    });

    test('deve manter interceptors após operações de token', () {
      const token = 'test-token';
      final interceptorCountBefore = dio.interceptors.length;

      dioClient.setAuthToken(token);
      dioClient.removeAuthToken();

      expect(dio.interceptors.length, equals(interceptorCountBefore));
    });
  });
}
