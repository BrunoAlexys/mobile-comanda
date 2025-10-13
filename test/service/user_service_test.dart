import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/repository/user_repository.dart';
import 'package:mobile_comanda/service/user_service.dart';

class MockUserRepository implements UserRepository {
  Map<String, dynamic>? _fetchUserResponse;
  Exception? _fetchUserException;

  void mockFetchUserSuccess(Map<String, dynamic> userData) {
    _fetchUserResponse = userData;
    _fetchUserException = null;
  }

  void mockFetchUserException(Exception exception) {
    _fetchUserException = exception;
    _fetchUserResponse = null;
  }

  void reset() {
    _fetchUserResponse = null;
    _fetchUserException = null;
  }

  @override
  Future<Map<String, dynamic>> fetchUser(String email) async {
    if (_fetchUserException != null) {
      throw _fetchUserException!;
    }
    if (_fetchUserResponse != null) {
      return _fetchUserResponse!;
    }
    throw Exception('No mock response configured');
  }
}

void main() {
  late UserService userService;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  tearDown(() {
    mockUserRepository.reset();
  });

  group('UserService - fetchUser', () {
    const testEmail = 'test@example.com';

    test(
      'deve retornar dados do usuário quando requisição é bem-sucedida',
      () async {
        final expectedUserData = {
          'id': 1,
          'email': testEmail,
          'name': 'Test User',
          'createdAt': '2023-01-01T00:00:00Z',
        };

        mockUserRepository.mockFetchUserSuccess(expectedUserData);

        final result = await userService.fetchUser(testEmail);

        expect(result, isA<Map<String, dynamic>>());
        expect(result, equals(expectedUserData));
        expect(result['id'], equals(1));
        expect(result['email'], equals(testEmail));
        expect(result['name'], equals('Test User'));
        expect(result['createdAt'], equals('2023-01-01T00:00:00Z'));
      },
    );

    test('deve retornar dados completos do usuário', () async {
      final completeUserData = {
        'id': 123,
        'email': 'john.doe@example.com',
        'name': 'John Doe',
        'firstName': 'John',
        'lastName': 'Doe',
        'role': 'user',
        'isActive': true,
        'createdAt': '2023-01-01T00:00:00Z',
        'updatedAt': '2023-01-02T00:00:00Z',
        'lastLogin': '2023-01-03T00:00:00Z',
        'preferences': {'theme': 'dark', 'language': 'pt-BR'},
      };

      mockUserRepository.mockFetchUserSuccess(completeUserData);

      final result = await userService.fetchUser('john.doe@example.com');

      expect(result, equals(completeUserData));
      expect(result['preferences'], isA<Map>());
      expect(result['preferences']['theme'], equals('dark'));
      expect(result['isActive'], isTrue);
    });

    test('deve retornar dados do usuário com campos opcionais nulos', () async {
      final userDataWithNulls = {
        'id': 456,
        'email': 'minimal@example.com',
        'name': 'Minimal User',
        'firstName': null,
        'lastName': null,
        'role': 'guest',
        'isActive': false,
        'createdAt': '2023-01-01T00:00:00Z',
        'updatedAt': null,
        'lastLogin': null,
        'preferences': null,
      };

      mockUserRepository.mockFetchUserSuccess(userDataWithNulls);

      final result = await userService.fetchUser('minimal@example.com');

      expect(result, equals(userDataWithNulls));
      expect(result['firstName'], isNull);
      expect(result['lastName'], isNull);
      expect(result['preferences'], isNull);
      expect(result['isActive'], isFalse);
    });

    test(
      'deve propagar exceção quando UserRepository lança Exception',
      () async {
        final repositoryException = Exception('Failed to load user data');
        mockUserRepository.mockFetchUserException(repositoryException);

        expect(
          () async => await userService.fetchUser(testEmail),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to load user data'),
            ),
          ),
        );
      },
    );

    test(
      'deve propagar exceção quando UserRepository lança exceção de rede',
      () async {
        final networkException = Exception('Network connection failed');
        mockUserRepository.mockFetchUserException(networkException);

        expect(
          () async => await userService.fetchUser(testEmail),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Network connection failed'),
            ),
          ),
        );
      },
    );

    test(
      'deve propagar exceção quando UserRepository lança exceção de timeout',
      () async {
        final timeoutException = Exception('Request timeout');
        mockUserRepository.mockFetchUserException(timeoutException);

        expect(
          () async => await userService.fetchUser(testEmail),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Request timeout'),
            ),
          ),
        );
      },
    );

    test(
      'deve propagar exceção quando UserRepository lança exceção de usuário não encontrado',
      () async {
        final notFoundException = Exception('User not found');
        mockUserRepository.mockFetchUserException(notFoundException);

        expect(
          () async => await userService.fetchUser('nonexistent@example.com'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('User not found'),
            ),
          ),
        );
      },
    );

    test('deve funcionar com emails de diferentes formatos', () async {
      const emails = [
        'simple@example.com',
        'test.email@domain.co.uk',
        'user+tag@example.org',
        'long.email.name@subdomain.example.com',
      ];

      for (final email in emails) {
        final userData = {
          'id': email.hashCode,
          'email': email,
          'name': 'User for $email',
          'createdAt': '2023-01-01T00:00:00Z',
        };

        mockUserRepository.mockFetchUserSuccess(userData);

        final result = await userService.fetchUser(email);

        expect(result['email'], equals(email));
        expect(result['name'], equals('User for $email'));

        mockUserRepository.reset();
      }
    });

    test('deve lidar com dados de usuário vazios mas válidos', () async {
      final emptyUserData = <String, dynamic>{};
      mockUserRepository.mockFetchUserSuccess(emptyUserData);

      final result = await userService.fetchUser(testEmail);

      expect(result, equals(emptyUserData));
      expect(result.isEmpty, isTrue);
    });

    test('deve preservar tipos de dados originais do repository', () async {
      final userDataWithMixedTypes = {
        'id': 789,
        'email': 'mixed@example.com',
        'name': 'Mixed Types User',
        'age': 25,
        'height': 175.5,
        'isActive': true,
        'tags': ['admin', 'developer'],
        'metadata': {'loginCount': 42, 'lastIp': '192.168.1.1'},
        'scores': [95.5, 87.2, 92.0],
      };

      mockUserRepository.mockFetchUserSuccess(userDataWithMixedTypes);

      final result = await userService.fetchUser('mixed@example.com');

      expect(result['id'], isA<int>());
      expect(result['age'], isA<int>());
      expect(result['height'], isA<double>());
      expect(result['isActive'], isA<bool>());
      expect(result['tags'], isA<List>());
      expect(result['metadata'], isA<Map>());
      expect(result['scores'], isA<List>());
      expect(result['scores'][0], isA<double>());
    });
  });
}
