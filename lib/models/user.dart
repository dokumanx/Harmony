import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.name, this.sugars, this.strength});

  factory UserData.fromDocumentSnapshot(
      String uid, DocumentSnapshot documentSnapshot) {
    return UserData(
        uid: uid,
        name: documentSnapshot.data['name'],
        sugars: documentSnapshot.data["sugars"],
        strength: documentSnapshot.data['strength']);
  }
}
