class Guest {
  final String id;
  final String email;
  final bool isSick; 
  final bool completedHealthScreen;

  Guest({
    required this.id,
    required this.email,
    required this.isSick,
    required this.completedHealthScreen
  });

  factory Guest.fromJson(String id, Map<String, dynamic> data) {
    return Guest(
      id: id,
      email: data["email"],
      isSick: data["isSick"],
      completedHealthScreen: data["completedHealthScreen"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "isSick": isSick,
      "completedHealthScreen": completedHealthScreen
    };
  }
}