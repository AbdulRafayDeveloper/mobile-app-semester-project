class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; 
  final String provider;
  final String? profileUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.provider,
    this.profileUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'provider': provider,
      'profileUrl': profileUrl ?? '',
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      provider: map['provider'] ?? 'email',
      profileUrl: map['profileUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
