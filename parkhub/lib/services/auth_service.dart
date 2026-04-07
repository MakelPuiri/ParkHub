import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    // TODO: implement login
    return null;
  }

  Future<UserModel?> register(
    String name,
    String email,
    String password,
  ) async {
    // TODO: implement register
    return null;
  }

  Future<void> logout() async {
    // TODO: implement logout
  }

  UserModel? getCurrentUser() {
    // TODO: implement getCurrentUser
    return null;
  }
}
