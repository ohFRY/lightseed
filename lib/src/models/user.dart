class User {
  final String id;
  final String email;
  final String fullName;

  User({required this.id, required this.email, this.fullName = ''});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
    };
  }
}
