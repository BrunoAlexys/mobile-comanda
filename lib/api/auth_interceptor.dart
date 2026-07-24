import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor({required this.dio, required this.navigatorKey});

  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthEndpoint(options.path)) {
      final secureStorageService = locator<SecureStorageService>();
      final accessToken = await secureStorageService.getAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // CORREÇÃO: Verificar tanto 401 quanto 403
    final statusCode = err.response?.statusCode;
    final isTokenError = statusCode == 401 || statusCode == 403;

    if (isTokenError && !_isAuthEndpoint(err.requestOptions.path)) {
      if (_isRefreshing) {
        // Adiciona à fila de requisições pendentes
        _pendingRequests.add(err.requestOptions);
        return handler.next(err);
      }

      _isRefreshing = true;

      try {
        final secureStorageService = locator<SecureStorageService>();
        final refreshToken = await secureStorageService.getRefreshToken();

        if (refreshToken == null) {
          return await _forceLogout(err, handler);
        }

        final newTokens = await _refreshToken(refreshToken);

        await secureStorageService.saveTokens(
          accessToken: newTokens['accessToken']!,
          refreshToken: newTokens['refreshToken']!,
        );

        // Atualiza header global
        dio.options.headers['Authorization'] =
            'Bearer ${newTokens['accessToken']}';

        // Reprocessa requisição original
        await _retryRequest(err.requestOptions, handler);

        // Reprocessa requisições pendentes
        await _processPendingRequests();
      } catch (e) {
        await _forceLogout(err, handler);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _processPendingRequests() async {
    final secureStorageService = locator<SecureStorageService>();
    final newAccessToken = await secureStorageService.getAccessToken();

    if (newAccessToken == null) return;

    for (final requestOptions in _pendingRequests) {
      try {
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        await dio.fetch(requestOptions);
      } catch (e) {
        debugPrint('Erro ao reprocessar requisição pendente: $e');
      }
    }

    _pendingRequests.clear();
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final secureStorageService = locator<SecureStorageService>();
    final newAccessToken = await secureStorageService.getAccessToken();

    if (newAccessToken != null) {
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      try {
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.reject(e);
      }
    } else {
      handler.reject(
        DioException(
          requestOptions: requestOptions,
          message: "Token de acesso indisponível para retry.",
        ),
      );
    }
  }

  Future<Map<String, String>> _refreshToken(String refreshToken) async {
    debugPrint('=== TENTANDO REFRESH TOKEN ===');
    debugPrint('Refresh token: ${refreshToken.substring(0, 20)}...');
    final dioRefresh = Dio(
      BaseOptions(
        baseUrl: dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ),
    );

    final response = await dioRefresh.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200 && response.data != null) {
      return {
        'accessToken': response.data['accessToken'] as String,
        'refreshToken': response.data['refreshToken'] as String,
      };
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }

  Future<void> _forceLogout(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final secureStorageService = locator<SecureStorageService>();
    await secureStorageService.clearTokens();

    _pendingRequests.clear();
    _isRefreshing = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    });

    handler.reject(err);
  }

  bool _isAuthEndpoint(String path) {
    final authEndpoints = ['/auth/login', '/auth/refresh'];
    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
