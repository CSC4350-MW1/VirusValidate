class Employee {
  final String id;
  final String email;
  
  Employee({
    required this.id,
    required this.email
  });

  factory Employee.fromJson(String id, Map<String, dynamic> data) {
    return Employee(id: id, email: data["email"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email
    };
  }
}