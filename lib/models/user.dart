import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony/models/user_notification.dart';

enum Gender { male, female }

class User {
  final String uid;
  final String name;
  // TODO : Check the type after you actually use this field.
  final FileImage fileImage;
  final Gender gender;
  final String email;
  final DateTime registrationDate;
  final UserNotification notification;
  final DateTime birthday;
  User(
      {this.uid,
      this.name,
      this.email,
      this.fileImage,
      this.gender,
      this.birthday,
      this.registrationDate,
      this.notification});
}

//TODO: Remove it later. It won't be necessary.
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
        sugars: documentSnapshot.data['sugars'],
        strength: documentSnapshot.data['strength']);
  }
}
