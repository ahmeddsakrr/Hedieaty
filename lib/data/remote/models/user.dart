class User {
  final String phoneNumber;
  final String name;
  final String email;
  String? profilePictureUrl;
  final String password;

  User({
    required this.phoneNumber,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      phoneNumber: map['phone_number'],
      name: map['name'],
      email: map['email'],
      profilePictureUrl: map['profile_picture_url'],
      password: map['password'],
    );
  }
}
