// models/user.dart
class User {
  final String firstName;
  final String email;

  User({required this.firstName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['FirstName'],
      email: json['Email'],
    );
  }
}
