import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:harmony/models/location.dart';
import 'package:harmony/models/patient.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class UserDataRepository {
  String _uid;

  void userID(String uid) {
    _uid = uid;
  }

  final CollectionReference patientCollection =
      Firestore.instance.collection('patients');
  final CollectionReference relativeCollection =
      Firestore.instance.collection('relatives');

  Future<void> updateRelativeData(
      {List<Patient> patients,
      int faceModel,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    return await relativeCollection.document(_uid).setData({
      "patients": patients ?? [],
      "faceModel": faceModel ?? 0,
      "uid": _uid,
      "name": name,
      "email": email ?? "unknown email",
      "fileImage": fileImage ?? "No image",
      "gender": gender ?? "Unknown",
      "birthday": birthday ?? '01.01.1990',
      "registrationDate": registrationDate ?? DateTime.now(),
      "notification": notification ?? "Not available"
    });
  }

  Future<void> updatePatientData(
      {List<Relative> relatives,
      List<TodoList> todoList,
      Location location,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    return await patientCollection.document(_uid).setData({
      "relatives": relatives ?? [],
      "todoList": todoList ?? [],
      "location": location ?? "Not available",
      "uid": _uid,
      "name": name ?? "newUser",
      "email": email ?? "unknown email",
      "fileImage": fileImage ?? "No image",
      "gender": gender ?? "Unknown",
      "birthday": birthday ?? '01.01.1990',
      "registrationDate": registrationDate ?? DateTime.now(),
      "notification": notification ?? "Not available"
    });
  }

  Relative _relativeDataFromSnapshot(DocumentSnapshot snapshot) {
    return Relative.relativeFromDocumentSnapshot(snapshot);
  }

  Stream<Relative> get getRelative {
    return relativeCollection
        .document(_uid)
        .snapshots()
        .map(_relativeDataFromSnapshot);
  }

  Patient _patientDataFromSnaphot(DocumentSnapshot snapshot) {
    return Patient.patientFromDocumentSnapshot(snapshot);
  }

  Stream<Patient> get getPatient {
    return patientCollection
        .document(_uid)
        .snapshots()
        .map(_patientDataFromSnaphot);
  }
}
