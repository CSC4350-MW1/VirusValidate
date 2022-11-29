class Guest {
  final String id;
  final String email;
  final bool isSick; 
  final bool completedHealthScreen;
  final bool unlockToken;
  final bool unlockedDoor;

  Guest({
    required this.id,
    required this.email,
    required this.isSick,
    required this.completedHealthScreen,
    required this.unlockToken,
    required this.unlockedDoor
  });

  factory Guest.fromJson(String id, Map<String, dynamic> data) {
    return Guest(
      id: id,
      email: data["email"],
      isSick: data["isSick"],
      completedHealthScreen: data["completedHealthScreen"],
      unlockToken: data["unlockToken"],
      unlockedDoor: data["unlockedDoor"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "isSick": isSick,
      "completedHealthScreen": completedHealthScreen,
      "unlockToken": unlockToken,
      "unlockedDoor": unlockedDoor
    };
  }
}