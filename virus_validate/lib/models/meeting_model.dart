

class Meeting {
  final String employee;
  final DateTime startTime;
  final DateTime endTime; 
  final List<String> guestList;

  Meeting({
    required this.employee,
    required this.startTime,
    required this.endTime,
    required this.guestList
  });

  factory Meeting.fromJson(String employee, Map<String, dynamic> data) {
    return Meeting(
      employee: employee, 
      startTime: data["startTime"], 
      endTime: data["endTime"], 
      guestList: data["guestList"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employee": employee,
      "startTime": startTime,
      "endTime": endTime,
      "guestList": guestList
    };
  }
}