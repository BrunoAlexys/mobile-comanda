import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_comanda/model/user.dart';
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
    debugPrint(
      '[UserStore] Ação loginAndFetchAndSetUser iniciada para: $email',
    );
    runInAction(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _authService.login(email, password);
      debugPrint(
        '[UserStore] Autenticação via AuthService concluída. Buscando dados do usuário...',
      );
      final userData = await _userService.fetchUser(email);

      runInAction(() {
        user = User.fromJson(userData);
        isLoading = false;
      });

      debugPrint(
        '[UserStore] Login e atribuição de usuário bem-sucedidos para: ${user?.email}',
      );
      return true;
    } catch (e) {
      runInAction(() {
        if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = 'Ocorreu um erro inesperado.';
        }
        isLoading = false;
        user = null;
      });
      debugPrint('[UserStore] Falha na ação loginAndFetchAndSetUser: $e');
      debugPrint('[UserStore] Mensagem de erro definida: $errorMessage');
      return false;
    }
  }

  @action
  Future<void> logout() async {
    debugPrint('[UserStore] Ação logout iniciada para: ${user?.email}');
    runInAction(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _authService.logout();
      runInAction(() {
        user = null;
        isLoading = false;
      });
      debugPrint('[UserStore] Logout bem-sucedido.');
    } catch (e) {
      runInAction(() {
        if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = 'Ocorreu um erro inesperado durante o logout.';
        }
        isLoading = false;
      });
      debugPrint('[UserStore] Falha na ação logout: $e');
      debugPrint('[UserStore] Mensagem de erro definida: $errorMessage');
    }
  }
}
