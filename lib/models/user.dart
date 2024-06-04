class User {
  String id;
  String name;
  String email;
  String position;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
  });

  // Метод для преобразования объекта в Map (для хранения в базе данных)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
    };
  }

  // Метод для создания объекта из Map (для чтения из базы данных)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      position: map['position'],
    );
  }
}