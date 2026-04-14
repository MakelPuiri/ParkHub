import 'app_user.dart';

/// Returned by AuthService on login or register attempts.
class AuthResult {
  final bool success;
  final String message;
  final AppUser? user;

  const AuthResult({required this.success, required this.message, this.user});
}
