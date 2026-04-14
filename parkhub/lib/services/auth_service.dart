import '../models/app_user.dart';
import '../models/auth_result.dart';

/// Handles registration and login for ParkHub.
/// Uses in-memory mock storage for MVP.
/// TODO: Replace mock logic with Supabase Auth when backend is connected.
class AuthService {
  // Singleton so the same user store is shared across the app.
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // In-memory user store (email → AppUser).
  final Map<String, AppUser> _users = {};
  AppUser? _currentUser;

  AppUser? getCurrentUser() => _currentUser;

  // ── Password validation ──────────────────────────────────────────────────

  /// Returns null if the password is valid, or an error message if not.
  static String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  // ── Registration ─────────────────────────────────────────────────────────

  Future<AuthResult> register({
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Field validation
    if (phoneNumber.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'All fields are required.',
      );
    }

    // Email format check
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email.trim())) {
      return const AuthResult(
        success: false,
        message: 'Please enter a valid email address.',
      );
    }

    // Password strength check
    final passwordError = validatePassword(password);
    if (passwordError != null) {
      return AuthResult(success: false, message: passwordError);
    }

    // Duplicate account check
    if (_users.containsKey(email.toLowerCase())) {
      return const AuthResult(
        success: false,
        message: 'An account with this email already exists.',
      );
    }

    // Create and store user
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: phoneNumber.trim(),
      email: email.trim().toLowerCase(),
      // MVP: storing password as-is. Replace with hashed token from Supabase Auth.
      passwordPlaceholder: password,
      createdAt: DateTime.now(),
    );

    _users[user.email] = user;
    _currentUser = user;

    return AuthResult(
      success: true,
      message: 'Account created successfully!',
      user: user,
    );
  }

  // ── Login ────────────────────────────────────────────────────────────────

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'Email and password are required.',
      );
    }

    final user = _users[email.trim().toLowerCase()];

    if (user == null || user.passwordPlaceholder != password) {
      return const AuthResult(
        success: false,
        message: 'Incorrect email or password.',
      );
    }

    _currentUser = user;
    return AuthResult(success: true, message: 'Welcome back!', user: user);
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}
