import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony/models/location.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class Patient extends User {
  final List<String> relatives;
  final List<TodoList> todoList;
  final Location location;

  Patient(
      {this.relatives,
      this.todoList,
      this.location,
      UserType userType,
      String uid,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification})
      : super(
            userType: userType,
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
      relatives: snapshot.data["relatives"],
      todoList: snapshot.data["todoList"],
      location: snapshot.data["location"],
      userType: snapshot.data["userType"],
      uid: snapshot.data["uid"],
      name: snapshot.data["name"],
      email: snapshot.data["email"],
      fileImage: snapshot.data["fileImage"],
      gender: snapshot.data["gender"],
      birthday: snapshot.data["birthday"],
      registrationDate: snapshot.data["registrationDate"],
      notification: snapshot.data["notification"],
    );
  }
}
