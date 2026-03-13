class User {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final List<String> profiles;
  final int? adminId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.profiles,
    this.adminId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telephone: json['telephone'],
      profiles: List<String>.from((json['profiles'] as List<dynamic>?) ?? []),
      adminId: json['adminId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'profiles': profiles,
      'adminId': adminId,
    };
  }
}
