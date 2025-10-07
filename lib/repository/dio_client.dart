import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = dotenv.env['BASE_URL']!
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
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
      throw 'Ocorreu um erro inesperado: $e';
    }
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.post(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'Ocorreu um erro inesperado: $e';
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.put(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'Ocorreu um erro inesperado: $e';
    }
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'Ocorreu um erro inesperado: $e';
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'Ocorreu um erro inesperado: $e';
    }
  }

  String _handleError(DioException error) {
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
            errorMessage = 'Não autorizado. Faça login novamente.';
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
    return errorMessage;
  }
}
