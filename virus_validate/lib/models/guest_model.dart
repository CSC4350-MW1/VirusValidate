class Guest {
  final String id;
  final String email;
  final bool isSick; 
  final bool completedHealthScreen;
  final bool unlockToken;
  final bool unlockedDoor;
  final List<dynamic> meetings;

  Guest({
    required this.id,
    required this.email,
    required this.isSick,
    required this.completedHealthScreen,
    required this.unlockToken,
    required this.unlockedDoor,
    required this.meetings
  });

  factory Guest.fromJson(String id, Map<String, dynamic> data) {
    return Guest(
      id: id,
      email: data["email"],
      isSick: data["isSick"],
      completedHealthScreen: data["completedHealthScreen"],
      unlockToken: data["unlockToken"],
      unlockedDoor: data["unlockedDoor"],
      meetings: (data["meetings"]) != null ? data["meetings"] : []

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "isSick": isSick,
      "completedHealthScreen": completedHealthScreen,
      "unlockToken": unlockToken,
      "unlockedDoor": unlockedDoor, 
      "meetings": meetings
    };
  }
}