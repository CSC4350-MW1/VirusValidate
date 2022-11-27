class Guest {
    final String id;
    final bool isSick; 
    final bool completedHealthScreen;

    Guest({
      required this.id,
      required this.isSick,
      required this.completedHealthScreen
    });

    factory Guest.fromJson(String id, Map<String, dynamic> data) {
      return Guest(
        id: id,
        isSick: data["isSick"],
        completedHealthScreen: data["completedHealthScreen"]
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "isSick": isSick,
        "completedHealthScreen": completedHealthScreen
      };
    }
}