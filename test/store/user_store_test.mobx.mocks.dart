import 'dart:async' as _i3;

import 'package:mobile_comanda/service/auth_service.dart' as _i4;
import 'package:mobile_comanda/service/user_service.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

class MockUserService extends _i1.Mock implements _i2.UserService {
  MockUserService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<String, dynamic>> fetchUser(String? email) =>
      (super.noSuchMethod(
            Invocation.method(#fetchUser, [email]),
            returnValue: _i3.Future<Map<String, dynamic>>.value(
              <String, dynamic>{},
            ),
          )
          as _i3.Future<Map<String, dynamic>>);
}

class MockAuthService extends _i1.Mock implements _i4.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> login(String? email, String? password) =>
      (super.noSuchMethod(
            Invocation.method(#login, [email, password]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}
