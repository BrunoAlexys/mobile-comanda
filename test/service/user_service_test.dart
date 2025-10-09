import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile_comanda/repository/user_repository.dart';
import 'package:mobile_comanda/service/user_service.dart';

import 'user_service_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late UserService userService;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  group('fetchUser', () {
    const testEmail = 'teste@email.com';
    final userData = {'id': 1, 'name': 'Usuário Teste', 'email': testEmail};

    test(
      'should return user data when repository call is successful',
      () async {
        when(
          mockUserRepository.fetchUser(testEmail),
        ).thenAnswer((_) async => userData);

        final result = await userService.fetchUser(testEmail);

        expect(result, userData);
        verify(mockUserRepository.fetchUser(testEmail)).called(1);
      },
    );

    test('should rethrow error when repository throws an error', () async {
      const errorMessage = 'Usuário não encontrado';
      when(mockUserRepository.fetchUser(testEmail)).thenThrow(errorMessage);

      expect(
        () => userService.fetchUser(testEmail),
        throwsA(equals(errorMessage)),
      );

      verify(mockUserRepository.fetchUser(testEmail)).called(1);
    });
  });
}
