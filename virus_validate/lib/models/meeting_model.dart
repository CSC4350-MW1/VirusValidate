

class Meeting {
  final String id;
  final String title;
  final String description;
  final String employee;
  final DateTime startTime;
  final DateTime endTime; 
  final List<dynamic> guestList;

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.employee,
    required this.startTime,
    required this.endTime,
    required this.guestList
  });

  factory Meeting.fromJson(String id, Map<String, dynamic> data) {
    return Meeting(
      id: id,
      title: data["title"],
      description: data["description"],
      employee: data["employee"], 
      startTime: DateTime.fromMicrosecondsSinceEpoch(data["startTime"].microsecondsSinceEpoch), 
      endTime: DateTime.fromMicrosecondsSinceEpoch(data["endTime"].microsecondsSinceEpoch), 
      guestList: data["guestList"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "employee": employee,
      "startTime": startTime,
      "endTime": endTime,
      "guestList": guestList
    };
  }
}