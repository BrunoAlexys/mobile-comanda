// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStoreBase, Store {
  Computed<bool>? _$isLoggedInComputed;

  @override
  bool get isLoggedIn => (_$isLoggedInComputed ??= Computed<bool>(
    () => super.isLoggedIn,
    name: '_UserStoreBase.isLoggedIn',
  )).value;

  late final _$userAtom = Atom(name: '_UserStoreBase.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_UserStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_UserStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loginAndFetchAndSetUserAsyncAction = AsyncAction(
    '_UserStoreBase.loginAndFetchAndSetUser',
    context: context,
  );

  @override
  Future<bool> loginAndFetchAndSetUser(String email, String password) {
    return _$loginAndFetchAndSetUserAsyncAction.run(
      () => super.loginAndFetchAndSetUser(email, password),
    );
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_UserStoreBase.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isLoggedIn: ${isLoggedIn}
    ''';
  }
}
