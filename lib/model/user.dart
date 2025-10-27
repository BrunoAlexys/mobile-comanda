class User {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final List<String> profiles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.profiles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telephone: json['telephone'],
      profiles: List<String>.from((json['profiles'] as List<dynamic>?) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'profiles': profiles,
    };
  }
}
