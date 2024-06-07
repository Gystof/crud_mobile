class Request {
  final String id;
  final String title;
  final String fullName;
  final String position;
  final String employeeNumber;
  final String department;
  final DateTime startDate;
  final DateTime endDate;

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

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      title: json['title'],
      fullName: json['fullName'],
      position: json['position'],
      employeeNumber: json['employeeNumber'],
      department: json['department'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
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
}
