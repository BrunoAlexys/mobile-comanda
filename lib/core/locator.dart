import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/repository/fee_repository.dart';
import 'package:mobile_comanda/repository/menu_repository.dart';
import 'package:mobile_comanda/repository/order_repository.dart';
import 'package:mobile_comanda/repository/tables_repository.dart';
import 'package:mobile_comanda/repository/user_repository.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/biometric_service.dart';
import 'package:mobile_comanda/service/fee_service.dart';
import 'package:mobile_comanda/service/menu_service.dart';
import 'package:mobile_comanda/service/order_service.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';
import 'package:mobile_comanda/service/tables_service.dart';
import 'package:mobile_comanda/service/user_service.dart';
import 'package:mobile_comanda/store/fee_store.mobx.dart';
import 'package:mobile_comanda/store/menu_store.mobx.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/store/tables_store.mobx.dart';
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

  locator.registerLazySingleton<MenuRepository>(
    () => MenuRepository(locator<DioClient>()),
  );

  locator.registerLazySingleton(() => FeeRepository(locator<DioClient>()));

  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepository(locator<DioClient>()),
  );

  locator.registerLazySingleton<TableRepository>(
    () => TableRepository(locator<DioClient>()),
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

  locator.registerLazySingleton<MenuService>(
    () => MenuService(locator<MenuRepository>()),
  );

  locator.registerLazySingleton(() => FeeService(locator<FeeRepository>()));

  locator.registerLazySingleton(() => OrderService(locator<OrderRepository>()));

  locator.registerLazySingleton(
    () => TablesService(locator<TableRepository>()),
  );

  locator.registerLazySingleton<UserStore>(
    () => UserStore(
      locator<UserService>(),
      locator<AuthService>(),
      locator<SecureStorageService>(),
    ),
  );

  locator.registerLazySingleton<OrderStore>(() => OrderStore());

  locator.registerLazySingleton<MenuStore>(
    () => MenuStore(locator<MenuService>()),
  );

  locator.registerLazySingleton(() => FeeStore(locator<FeeService>()));

  locator.registerLazySingleton(() => TablesStore(locator<TablesService>()));
}
