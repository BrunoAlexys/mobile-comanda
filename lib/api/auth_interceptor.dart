import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor({required this.dio, required this.navigatorKey});

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
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path)) {
      final secureStorageService = locator<SecureStorageService>();
      final refreshToken = await secureStorageService.getRefreshToken();
      if (refreshToken == null) {
        return handler.next(err);
      }

      try {
        final newToken = await _refreshToken(refreshToken);
        await secureStorageService.saveTokens(
          accessToken: newToken['accessToken']!,
          refreshToken: newToken['refreshToken']!,
        );

        err.requestOptions.headers['Authorization'] =
            'Bearer ${newToken['accessToken']}';

        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        await secureStorageService.clearTokens();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );

        return handler.next(err);
      }
    }
    handler.next(err);
  }

  Future<Map<String, String>> _refreshToken(String refreshToken) async {
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

  bool _isAuthEndpoint(String path) {
    final authEndpoints = ['/auth/login'];

    final isAuthEndpoint = authEndpoints.any(
      (endpoint) => path.contains(endpoint),
    );

    return isAuthEndpoint;
  }
}
