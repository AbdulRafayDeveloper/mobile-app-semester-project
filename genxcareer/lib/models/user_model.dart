class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // Either 'user' or 'admin'
  final String? profileUrl; // Nullable, will be updated later
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.profileUrl, // Nullable field
    required this.createdAt,
  });

  // Convert a UserModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'profileUrl': profileUrl ?? '', // Empty string if not provided
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a UserModel instance from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user', // Default role is 'user'
      profileUrl: map['profileUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
