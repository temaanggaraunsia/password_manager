class User {
  final int? userId;
  final String username;
  final String fullName;
  final String password;

  User({
    this.userId,
    required this.username,
    required this.fullName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'full_name': fullName,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      fullName: map['full_name'],
      password: map['password'],
    );
  }
}
