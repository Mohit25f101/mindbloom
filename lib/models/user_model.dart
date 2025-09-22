class UserModel {
  final String username;
  final String email;
  final DateTime lastLogin;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.username,
    required this.email,
    DateTime? lastLogin,
    this.preferences,
  }) : lastLogin = lastLogin ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
      email: json['email'] as String,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'lastLogin': lastLogin.toIso8601String(),
      'preferences': preferences,
    };
  }
}
