class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';
}
