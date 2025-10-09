import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/service/auth_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthService authService;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor({
    required this.dio,
    required this.authService,
    required this.navigatorKey,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await authService.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await authService.getRefreshToken();
      if (refreshToken == null) {
        return handler.next(err);
      }

      try {
        final newToken = await _refreshToken(refreshToken);
        await authService.saveTokens(
          accessToken: newToken['accessToken']!,
          refreshToken: newToken['refreshToken']!,
        );

        err.requestOptions.headers['Authorization'] =
            'Bearer ${newToken['accessToken']}';

        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        await authService.clearTokens();
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
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
      };
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }
}
