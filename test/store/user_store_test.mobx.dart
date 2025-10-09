import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/model/user.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/user_service.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;

import 'user_store_test.mobx.mocks.dart';
import '../repository/user_repository_test.mocks.dart';

@GenerateMocks([UserService, AuthService])
void main() {
  late UserStore userStore;
  late MockUserService mockUserService;
  late MockAuthService mockAuthService;
  late MockDioClient mockDioClient;
  final getIt = GetIt.instance;

  setUp(() {
    mockUserService = MockUserService();
    mockAuthService = MockAuthService();
    mockDioClient = MockDioClient();
    userStore = UserStore(mockUserService, mockAuthService);

    getIt.registerSingleton<DioClient>(mockDioClient);
  });

  tearDown(() {
    getIt.reset();
  });

  group('loginAndFetchAndSetUser', () {
    const testEmail = 'teste@email.com';
    const testPassword = 'password123';
    const testToken = 'fake-jwt-token';
    final userData = {'id': 1, 'name': 'Usuário Teste', 'email': testEmail};

    test(
      'should set user and return true when login and fetch are successful',
      () async {
        mockito
            .when(mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => testToken);
        mockito
            .when(mockUserService.fetchUser(testEmail))
            .thenAnswer((_) async => userData);
        mockito
            .when(mockDioClient.setAuthToken(testToken))
            .thenAnswer((_) async => Future.value());

        final result = await userStore.loginAndFetchAndSetUser(
          testEmail,
          testPassword,
        );

        expect(result, isTrue);
        expect(userStore.user, isA<User>());
        expect(userStore.user!.email, testEmail);
        expect(userStore.isLoggedIn, isTrue);
        expect(userStore.isLoading, isFalse);
        expect(userStore.errorMessage, isNull);
        mockito
            .verify(mockAuthService.login(testEmail, testPassword))
            .called(1);
        mockito.verify(mockDioClient.setAuthToken(testToken)).called(1);
        mockito.verify(mockUserService.fetchUser(testEmail)).called(1);
      },
    );

    test('should set errorMessage and return false when auth fails', () async {
      const authError = 'Credenciais inválidas';
      mockito
          .when(mockAuthService.login(testEmail, testPassword))
          .thenThrow(authError);

      final result = await userStore.loginAndFetchAndSetUser(
        testEmail,
        testPassword,
      );

      expect(result, isFalse);
      expect(userStore.user, isNull);
      expect(userStore.isLoggedIn, isFalse);
      expect(userStore.isLoading, isFalse);
      expect(userStore.errorMessage, authError);
      mockito.verify(mockAuthService.login(testEmail, testPassword)).called(1);
      mockito.verifyNever(mockDioClient.setAuthToken(mockito.any));
      mockito.verifyNever(mockUserService.fetchUser(mockito.any));
    });

    test(
      'should set errorMessage and return false when user fetch fails',
      () async {
        const fetchError = 'Usuário não encontrado';
        mockito
            .when(mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => testToken);
        mockito
            .when(mockUserService.fetchUser(testEmail))
            .thenThrow(fetchError);
        mockito
            .when(mockDioClient.setAuthToken(testToken))
            .thenAnswer((_) async => Future.value());

        final result = await userStore.loginAndFetchAndSetUser(
          testEmail,
          testPassword,
        );

        expect(result, isFalse);
        expect(userStore.user, isNull);
        expect(userStore.isLoggedIn, isFalse);
        expect(userStore.isLoading, isFalse);
        expect(userStore.errorMessage, fetchError);
        mockito
            .verify(mockAuthService.login(testEmail, testPassword))
            .called(1);
        mockito.verify(mockDioClient.setAuthToken(testToken)).called(1);
        mockito.verify(mockUserService.fetchUser(testEmail)).called(1);
      },
    );
  });
}
