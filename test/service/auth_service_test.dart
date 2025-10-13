import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/enum/biometric_preference.dart';
import 'package:mobile_comanda/repository/auth_repository.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';

class MockAuthRepository implements AuthRepository {
  Map<String, String>? _loginResponse;
  Exception? _loginException;

  void mockLoginSuccess(Map<String, String> tokens) {
    _loginResponse = tokens;
    _loginException = null;
  }

  void mockLoginException(Exception exception) {
    _loginException = exception;
    _loginResponse = null;
  }

  void reset() {
    _loginResponse = null;
    _loginException = null;
  }

  @override
  Future<Map<String, String>> login(String email, String password) async {
    if (_loginException != null) {
      throw _loginException!;
    }
    if (_loginResponse != null) {
      return _loginResponse!;
    }
    throw Exception('No mock response configured');
  }
}

class MockSecureStorageService implements SecureStorageService {
  bool _saveTokensCalled = false;
  bool _clearTokensCalled = false;
  String? _savedAccessToken;
  String? _savedRefreshToken;
  Exception? _saveTokensException;
  Exception? _clearTokensException;

  bool get saveTokensCalled => _saveTokensCalled;
  bool get clearTokensCalled => _clearTokensCalled;
  String? get savedAccessToken => _savedAccessToken;
  String? get savedRefreshToken => _savedRefreshToken;

  void mockSaveTokensException(Exception exception) {
    _saveTokensException = exception;
  }

  void mockClearTokensException(Exception exception) {
    _clearTokensException = exception;
  }

  void reset() {
    _saveTokensCalled = false;
    _clearTokensCalled = false;
    _savedAccessToken = null;
    _savedRefreshToken = null;
    _saveTokensException = null;
    _clearTokensException = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (_saveTokensException != null) {
      throw _saveTokensException!;
    }
    _saveTokensCalled = true;
    _savedAccessToken = accessToken;
    _savedRefreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    if (_clearTokensException != null) {
      throw _clearTokensException!;
    }
    _clearTokensCalled = true;
  }

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> saveCredentials(String email, String password) async {}

  @override
  Future<Map<String, String?>> getCredentials() async => {
    'email': null,
    'password': null,
  };

  @override
  Future<void> clearCredentials() async {}

  @override
  Future<BiometricPreference> getBiometricPreference() async =>
      BiometricPreference.notChoosen;

  @override
  Future<void> setBiometricPreference(BiometricPreference preference) async {}

  @override
  Future<bool> isBiometricEnabled() async => false;
}

class MockNavigatorState extends NavigatorState {
  String? _pushedRoute;
  bool? _removeUntilCalled;

  String? get pushedRoute => _pushedRoute;
  bool? get removeUntilCalled => _removeUntilCalled;

  void reset() {
    _pushedRoute = null;
    _removeUntilCalled = null;
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) async {
    _pushedRoute = routeName;
    _removeUntilCalled = true;
    return null;
  }
}

void main() {
  late AuthService authService;
  late MockAuthRepository mockAuthRepository;
  late MockSecureStorageService mockSecureStorageService;
  late MockNavigatorState mockNavigatorState;
  late GlobalKey<NavigatorState> navigatorKey;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStorageService = MockSecureStorageService();
    mockNavigatorState = MockNavigatorState();
    navigatorKey = GlobalKey<NavigatorState>();

    navigatorKey = GlobalKey<NavigatorState>();

    authService = AuthService(
      mockAuthRepository,
      mockSecureStorageService,
      navigatorKey,
    );
  });

  tearDown(() {
    mockAuthRepository.reset();
    mockSecureStorageService.reset();
    mockNavigatorState.reset();
  });

  group('AuthService - login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testAccessToken = 'access_token_123';
    const testRefreshToken = 'refresh_token_456';

    test('deve executar login com sucesso e salvar tokens', () async {
      final expectedTokens = {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
      };
      mockAuthRepository.mockLoginSuccess(expectedTokens);

      await authService.login(testEmail, testPassword);

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
      expect(mockSecureStorageService.saveTokensCalled, isTrue);
      expect(
        mockSecureStorageService.savedAccessToken,
        equals(testAccessToken),
      );
      expect(
        mockSecureStorageService.savedRefreshToken,
        equals(testRefreshToken),
      );
    });

    test('deve limpar tokens antes de tentar login', () async {
      final expectedTokens = {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
      };
      mockAuthRepository.mockLoginSuccess(expectedTokens);

      await authService.login(testEmail, testPassword);

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
    });

    test('deve lançar exceção quando accessToken é null', () async {
      final tokensWithNullAccess = <String, String>{
        'refreshToken': testRefreshToken,
      };
      mockAuthRepository.mockLoginSuccess(tokensWithNullAccess);

      expect(
        () async => await authService.login(testEmail, testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Tokens de acesso ou atualização nulos recebidos do repositório',
            ),
          ),
        ),
      );

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
      expect(mockSecureStorageService.saveTokensCalled, isFalse);
    });

    test('deve lançar exceção quando refreshToken é null', () async {
      final tokensWithNullRefresh = <String, String>{
        'accessToken': testAccessToken,
      };
      mockAuthRepository.mockLoginSuccess(tokensWithNullRefresh);

      expect(
        () async => await authService.login(testEmail, testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Tokens de acesso ou atualização nulos recebidos do repositório',
            ),
          ),
        ),
      );

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
      expect(mockSecureStorageService.saveTokensCalled, isFalse);
    });

    test('deve propagar exceção quando AuthRepository lança exceção', () async {
      final repositoryException = Exception('Repository error');
      mockAuthRepository.mockLoginException(repositoryException);

      expect(
        () async => await authService.login(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
      expect(mockSecureStorageService.saveTokensCalled, isFalse);
    });

    test('deve continuar processo mesmo se clearTokens falhar', () async {
      final expectedTokens = {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
      };
      mockAuthRepository.mockLoginSuccess(expectedTokens);
      mockSecureStorageService.mockClearTokensException(
        Exception('Clear tokens failed'),
      );

      expect(
        () async => await authService.login(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('deve propagar exceção quando saveTokens falha', () async {
      final expectedTokens = {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
      };
      mockAuthRepository.mockLoginSuccess(expectedTokens);
      mockSecureStorageService.mockSaveTokensException(
        Exception('Save tokens failed'),
      );

      expect(
        () async => await authService.login(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
    });
  });

  group('AuthService - logout', () {
    test('deve executar logout com sucesso', () async {
      await authService.logout();

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
    });

    testWidgets('deve navegar para tela de login após logout', (
      WidgetTester tester,
    ) async {
      final testWidget = MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/home',
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
          '/login': (context) => const Scaffold(body: Text('Login')),
        },
      );

      await tester.pumpWidget(testWidget);

      final authServiceWithRealNavigator = AuthService(
        mockAuthRepository,
        mockSecureStorageService,
        navigatorKey,
      );

      await authServiceWithRealNavigator.logout();
      await tester.pumpAndSettle();

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
      expect(find.text('Login'), findsOneWidget);
    });

    test('deve continuar logout mesmo se clearTokens falhar', () async {
      mockSecureStorageService.mockClearTokensException(
        Exception('Clear tokens failed'),
      );

      await authService.logout();

      expect(true, isTrue);
    });

    test('deve lidar com navigator state nulo sem falhar', () async {
      final authServiceWithNullNavigator = AuthService(
        mockAuthRepository,
        mockSecureStorageService,
        GlobalKey<NavigatorState>(),
      );

      await authServiceWithNullNavigator.logout();

      expect(mockSecureStorageService.clearTokensCalled, isTrue);
    });
  });
}
