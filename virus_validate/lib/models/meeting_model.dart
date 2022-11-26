

class Meeting {
  final String id;
  final String title;
  final String description;
  final String employee;
  final DateTime startTime;
  final DateTime endTime; 
  final List<String> guestList;

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
      startTime: data["startTime"], 
      endTime: data["endTime"], 
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