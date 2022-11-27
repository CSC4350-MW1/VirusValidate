class Employee {
  final String email;
  
  Employee({
    required this.email
  });

  factory Employee.fromJson(Map<String, dynamic> data) {
    return Employee(email: data["email"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email
    };
  }
}