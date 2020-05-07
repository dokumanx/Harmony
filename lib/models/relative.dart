import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony/models/patient.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class Relative extends User {
  final List<Patient> patients;
  final int faceModel;

  Relative(
      {this.patients,
      this.faceModel,
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

  factory Relative.relativeFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Relative(
      patients: snapshot.data["patients"],
      faceModel: snapshot.data["faceModel"],
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
