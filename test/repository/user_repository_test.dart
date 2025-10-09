import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/repository/user_repository.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late UserRepository userRepository;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    userRepository = UserRepository(mockDioClient);
  });

  group('fetchUser', () {
    const testEmail = 'teste@email.com';
    final userJson = {'id': 1, 'name': 'Usuário Teste', 'email': testEmail};

    test('should return user data when the call is successful (200)', () async {
      final fakeResponse = Response(
        statusCode: 200,
        data: userJson,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );

      when(
        mockDioClient.get('/users/$testEmail'),
      ).thenAnswer((_) async => fakeResponse);

      final result = await userRepository.fetchUser(testEmail);

      expect(result, userJson);
      verify(mockDioClient.get('/users/$testEmail')).called(1);
    });

    test(
      'should rethrow the error when DioClient throws an exception',
      () async {
        const errorMessage = 'Erro de conexão';
        when(mockDioClient.get('/users/$testEmail')).thenThrow(errorMessage);

        expect(
          () => userRepository.fetchUser(testEmail),
          throwsA(equals(errorMessage)),
        );

        verify(mockDioClient.get('/users/$testEmail')).called(1);
      },
    );

    test('should throw an exception for non-200 status code', () async {
      final fakeResponse = Response(
        statusCode: 404,
        requestOptions: RequestOptions(path: '/users/$testEmail'),
      );
      when(
        mockDioClient.get('/users/$testEmail'),
      ).thenAnswer((_) async => fakeResponse);

      expect(
        () => userRepository.fetchUser(testEmail),
        throwsA(equals('Resposta inesperada do servidor')),
      );
    });

    test(
      'should throw an exception for 200 status code with null data',
      () async {
        final fakeResponse = Response(
          statusCode: 200,
          data: null,
          requestOptions: RequestOptions(path: '/users/$testEmail'),
        );
        when(
          mockDioClient.get('/users/$testEmail'),
        ).thenAnswer((_) async => fakeResponse);

        expect(
          () => userRepository.fetchUser(testEmail),
          throwsA(equals('Resposta inesperada do servidor')),
        );
      },
    );
  });
}
