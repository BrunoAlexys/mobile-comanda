import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/repository/user_repository.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/biometric_service.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';
import 'package:mobile_comanda/service/user_service.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';

final locator = GetIt.instance;

void setupLocator(GlobalKey<NavigatorState> navigatorKey) {
  locator.registerLazySingleton<Dio>(() => Dio());

  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  locator.registerLazySingleton<LocalAuthentication>(
    () => LocalAuthentication(),
  );

  locator.registerLazySingleton<DioClient>(
    () => DioClient(locator<Dio>(), navigatorKey),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(locator<DioClient>()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepository(locator<DioClient>()),
  );

  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<AuthService>(
    () => AuthService(
      locator<AuthRepository>(),
      locator<SecureStorageService>(),
      navigatorKey,
    ),
  );
  locator.registerLazySingleton<UserService>(
    () => UserService(locator<UserRepository>()),
  );
  locator.registerLazySingleton<BiometricService>(
    () => BiometricService(locator<LocalAuthentication>()),
  );

  // ## STORES (CONTROLE DE ESTADO) ##
  locator.registerLazySingleton<UserStore>(
    () => UserStore(locator<UserService>(), locator<AuthService>()),
  );
}
