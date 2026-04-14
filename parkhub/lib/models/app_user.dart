/// Represents a registered ParkHub user.
/// TODO: Map to Supabase Auth user object when backend is connected.
class AppUser {
  final String id;
  final String phoneNumber;
  final String email;
  // NOTE: In production this would never be stored in plain text.
  // For MVP demo purposes only — replace with Supabase Auth token/session.
  final String passwordPlaceholder;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.passwordPlaceholder,
    required this.createdAt,
  });
}
