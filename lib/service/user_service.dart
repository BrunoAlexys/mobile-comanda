import 'package:mobile_comanda/repository/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<Map<String, dynamic>> fetchUser(String email) async {
    try {
      final userData = await _userRepository.fetchUser(email);
      return userData;
    } catch (e) {
      rethrow;
    }
  }
}
