import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class Patient extends User {
  final List<Relative> relatives;
  final List<TodoList> todoList;
  final Location location;

  Patient(
      {this.relatives,
      this.todoList,
      this.location,
      String uid,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification})
      : super(
            uid: uid,
            name: name,
            email: email,
            fileImage: fileImage,
            gender: gender,
            birthday: birthday,
            registrationDate: registrationDate,
            notification: notification);

  factory Patient.patientFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Patient(
      notification: snapshot.data["notification"],
      registrationDate: snapshot.data["registrationDate"],
      birthday: snapshot.data["birthday"],
      gender: snapshot.data["gender"],
      fileImage: snapshot.data["fileImage"],
      email: snapshot.data["email"],
      name: snapshot.data["name"],
      uid: snapshot.data["uid"],
      location: snapshot.data["location"],
      relatives: snapshot.data["relatives"],
      todoList: snapshot.data["todoList"],
    );
  }
}
