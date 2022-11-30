class Door {
  final String id;
  final bool locked;

  Door({required this.id, required this.locked});

  factory Door.fromJson(String id, Map<String, dynamic> data) {
    return Door(id: id, locked: data["locked"]);
  }

  Map<String, dynamic> toJson() {
    return {"locked": locked};
  }
}
