import 'package:team_up/api/auth_model.dart';

class AuthViewModel {
  final AuthModel _authModel;

  AuthViewModel() : _authModel = AuthModel();

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _authModel.signup(name: name, email: email, password: password);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) {
    return _authModel.login(email: email, password: password);
  }

  Future<String?> getToken() {
    return _authModel.getToken();
  }
}
