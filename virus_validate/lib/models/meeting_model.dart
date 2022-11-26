

class Meeting {
  final String title;
  final String description;
  final String employee;
  final DateTime startTime;
  final DateTime endTime; 
  final List<String> guestList;

  Meeting({
    required this.title,
    required this.description,
    required this.employee,
    required this.startTime,
    required this.endTime,
    required this.guestList
  });

  factory Meeting.fromJson(String employee, Map<String, dynamic> data) {
    return Meeting(
      title: data["title"],
      description: data["description"],
      employee: employee, 
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