import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/model/user.dart';
import 'package:mobile_comanda/repository/dio_client.dart';
import 'package:mobile_comanda/service/auth_service.dart';
import 'package:mobile_comanda/service/user_service.dart';
import 'package:mobx/mobx.dart';

part 'user_store.mobx.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store {
  final UserService _userService;
  final AuthService _authService;

  _UserStoreBase(this._userService, this._authService);

  @observable
  User? user;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get isLoggedIn => user != null;

  @action
  Future<bool> loginAndFetchAndSetUser(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      final String token = await _authService.login(email, password);
      final dioClient = GetIt.I<DioClient>();
      dioClient.setAuthToken(token);

      final userData = await _userService.fetchUser(email);
      user = User.fromJson(userData);
      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      return false;
    }
  }
}
