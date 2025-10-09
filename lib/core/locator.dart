import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/repository/user_repository.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/user_service.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';

final locator = GetIt.instance;

void setupLocator(GlobalKey<NavigatorState> navigatorKey) {
  locator.registerLazySingleton<Dio>(() => Dio());
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(locator<DioClient>()),
  );

  locator.registerLazySingleton<AuthService>(
    () =>
        AuthService(locator<AuthRepository>(), locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<DioClient>(
    () => DioClient(locator<Dio>(), navigatorKey),
  );

  locator.registerLazySingleton<UserRepository>(
    () => UserRepository(locator<DioClient>()),
  );

  locator.registerLazySingleton<UserService>(
    () => UserService(locator<UserRepository>()),
  );

  locator.registerLazySingleton<UserStore>(
    () => UserStore(locator<UserService>(), locator<AuthService>()),
  );
}
