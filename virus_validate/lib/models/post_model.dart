import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String message;
  int type = 0;
  final Timestamp created;
  final String name;

  Post({required this.id, required this.message,required this.type, required this.created, required this.name});

  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      message: data["message"],
      type: data["type"] ?? 0,
      created: data["created"],
      name: data["name"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "type": type,
      "created": created,
      "name": name
    };
  }

  Post.fromSnapshot(snapshot) 
    : id = snapshot.data()['id'],
      message = snapshot.data()['message'],
      created = snapshot.data()['created'],
      name = snapshot.data()['name'];
}