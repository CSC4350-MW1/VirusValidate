class Employee {
  final String id;
  final String name;
  final String email;
  
  Employee({
    required this.id,
    required this.email,
    required this.name
  });

  factory Employee.fromJson(String id, Map<String, dynamic> data) {
    return Employee(id: id, email: data["email"], name: data["name"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name
    };
  }
}