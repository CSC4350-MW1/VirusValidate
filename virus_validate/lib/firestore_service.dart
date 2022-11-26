
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String getUserID() {
    return auth.currentUser!.uid;
  }

  final meetingCollection = FirebaseFirestore.instance.collection('Meetings');
  final guestCollection = FirebaseFirestore.instance.collection('Guests');
}