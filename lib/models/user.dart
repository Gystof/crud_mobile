class User {
  final String id;
  final String name;
  final String email;
  final String position;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
    };
  }
}
