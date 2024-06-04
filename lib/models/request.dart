class Request {
  String id;
  String title;
  String fullName;
  String position;
  String employeeNumber;
  String department;
  DateTime startDate;
  DateTime endDate;

  Request({
    required this.id,
    required this.title,
    required this.fullName,
    required this.position,
    required this.employeeNumber,
    required this.department,
    required this.startDate,
    required this.endDate,
  });

  // Метод для преобразования объекта в Map (для хранения в базе данных)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fullName': fullName,
      'position': position,
      'employeeNumber': employeeNumber,
      'department': department,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  // Метод для создания объекта из Map (для чтения из базы данных)
  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      title: map['title'],
      fullName: map['fullName'],
      position: map['position'],
      employeeNumber: map['employeeNumber'],
      department: map['department'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}