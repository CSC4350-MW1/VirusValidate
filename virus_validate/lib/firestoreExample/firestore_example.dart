/* import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/models/conversation_model.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Map<String, Profile> profileMap = {};
  static Map<String, Post> postMap = {};
  static Map<String, Conversation> conversationsMap = {};
  final Map<String, Message> _messages = {};

  String getUserID() {
    return _auth.currentUser!.uid;
  }

  final profileCollection = FirebaseFirestore.instance.collection("users");
  final postsCollection = FirebaseFirestore.instance.collection("posts");
  final conversationCollection = FirebaseFirestore.instance.collection("conversations");
  final userConversationsCollection = FirebaseFirestore.instance.collection("user-conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  final StreamController<Map<String, Profile>> _profileController = StreamController<Map<String, Profile>>();
  final StreamController<List<Post>> _postsController = StreamController<List<Post>>();
  final StreamController<List<Conversation>> _conversationsController = StreamController<List<Conversation>>();
  final StreamController<List<Conversation>> _userConversationsController = StreamController<List<Conversation>>();
  final StreamController<List<Message>> _messagesController = StreamController<List<Message>>();

  Stream<Map<String, Profile>> get profiles => _profileController.stream;
  Stream<List<Post>> get posts => _postsController.stream;  
  Stream<List<Conversation>> get conversations => _conversationsController.stream;
  Stream<List<Conversation>> get userConvos => _userConversationsController.stream;
  Stream<List<Message>> get messages => _messagesController.stream;

  FirestoreService(){
    profileCollection.snapshots().listen(_profilesUpdated);
    postsCollection.orderBy("created", descending: true).snapshots().listen(_postsUpdated);
    messagesCollection.snapshots().listen(_messagesUpdated);
    conversationCollection.snapshots().listen(_conversationUpdated);
  }

  void _profilesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, Profile> profiles = _getProfileFromSnapshot(snapshot);
    _profileController.add(profiles);
  }

  void setUserConversations() {
    userConversationsCollection.doc(_auth.currentUser!.uid).snapshots().listen(_userConvosUpdated);
  }

  void setConvoMessages(String convoId) {
    messagesCollection
      .where("conversationId", isEqualTo: convoId)
      .orderBy("created",descending: true)
      .snapshots()
      .listen(_messagesUpdated);
  }

  Stream<List<Message>> convoMessages() {
    return _messagesController.stream;
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = _getMessagesFromSnapshot(snapshot);
    _messagesController.add(messages);
  }

  void _conversationUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = _getConversationsFromSnapshot(snapshot);
    _conversationsController.add(conversations);
  }

  void _userConvosUpdated(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> userConvo = _getUserConvosFromSnapshot(snapshot);
    _userConversationsController.add(userConvo);
  }

  Map<String, Profile> _getProfileFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var doc in snapshot.docs) {
      Profile profile = Profile.fromJson(doc.id, doc.data());
      profileMap[profile.email] = profile;
    }
    return profileMap;
  }

  List<Post> _getPostsFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      Post post = Post.fromJson(data['id'], doc.data());
      posts.add(post);
      postMap[post.email] = post;
    }
    return posts;
  }

  List<Conversation> _getConversationsFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = [];
    for (var doc in snapshot.docs) {
      Conversation convo = Conversation.fromJson(doc.id, doc.data());
      conversationsMap[convo.email] = convo;
      conversations.add(convo);
    }
    return conversations;
  }

  List<Conversation> _getUserConvosFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = [];
    log(snapshot.data()!.toString());
    if (snapshot.data() != null) {
      for (var key in snapshot.data()!.keys) {
        if (conversationsMap.containsKey(key)) {
          conversations.add(conversationsMap[key]!);
        }
      }
    }
    return conversations;
  }

  List<Message> _getMessagesFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = [];
    for (var doc in snapshot.docs) {
      Message message = Message.fromJson(doc.id, doc.data());
      messages.add(message);
      _messages[message.email] = message;
    }
    messages.sort(((a, b) => a.created.compareTo(b.created)));
    return messages;  
  }


  Future<bool> addUser(String userId, Map<String, dynamic> data) async {
    try {
      await profileCollection.doc(userId).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPost(Map<String, dynamic> data) async {
    data["created"] = Timestamp.now();
    try {
      await postsCollection.add(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<Conversation?> addConversation(List<String> users) async {
    users.add(_auth.currentUser!.uid);
    var data = Conversation(
      email: "id", 
      users: users, 
      created: Timestamp.now(), 
      ratings: <String, dynamic>{});
    try {
      var result = await conversationCollection.add(data.toJSON());
      for (var user in users) {
        userConversationsCollection.doc(user).set({result.id: 1}, SetOptions(merge: true));
      }
      return Conversation(
        email: result.id, 
        users: users, 
        created: data.created, 
        ratings: data.ratings);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addMessage(String content, Conversation convo) async {
    var data = Message(
      email: "", 
      content: content, 
      type: 0, 
      created: Timestamp.now(), 
      fromID: getUserID(), 
      convoID: convo.email);
    try {
      var result = await messagesCollection.add(data.toJSON());
      await conversationCollection.doc(convo.email).update(Conversation(
              email: convo.email, 
              users: convo.users, 
              created: convo.created,
              lastMessage: result.id,
              ratings: convo.ratings)
              .toJSON());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rateConvo(Conversation convo, double rating) async {
    Map<String, dynamic> ratings = convo.ratings;
    String uid = getUserID();
    if (ratings.containsKey(uid)){
      ratings.update(uid, (value) => rating);
    } else {
      ratings.putIfAbsent(uid, () => rating);
    }

    try {
      await conversationCollection.doc(convo.email).update({
        "ratings" : ratings
      });
      double avgConvoRating = avgRating(ratings);
      for (var user in convo.users) {
        Map<String, dynamic> usrRatings = profileMap[user]!.ratings;
        if (usrRatings.containsKey(convo.email)) {
          usrRatings.update(convo.email, (value) => avgConvoRating);
        } else {
          usrRatings.putIfAbsent(convo.email, () => avgConvoRating);
        }
        await profileCollection.doc(user).update({
          "ratings" : usrRatings
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> rateUser(Profile user, double rating) async {
    Map<String, dynamic> ratings = user.ratings;
    String uid = getUserID();
    if (ratings.containsKey(uid)) {
      ratings.update(uid, (value) => rating);
    } else {
      ratings.putIfAbsent(uid, () => rating);
    }

    await profileCollection.doc(user.email).update({
      "ratings": ratings
    }).then((value) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static double avgRating(Map<String, dynamic> ratings) {
    double result = 0.0;
    if (ratings.isEmpty) {
      return result;
    }
    for (var val in ratings.values) {
      result += val ;
    }
    return result / ratings.length;
  }
} */