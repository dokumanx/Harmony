import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:harmony/models/patient.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class UserDataRepository {
  final String _uid;

  UserDataRepository(@required uid)
      : _uid = uid,
        assert(uid != null);

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
      "patients": patients,
      "faceModel": faceModel,
      "uid": _uid,
      "name": name,
      "email": email,
      "fileImage": fileImage,
      "gender": gender,
      "birthday": birthday,
      "registrationDate": registrationDate,
      "notification": notification
    });
  }

  Future<void> updatePatientData(
      {List<Relative> relatives,
      List<TodoList> todoList,
      Location location,
      String uid,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    return await patientCollection.document(_uid).setData({
      "relatives": relatives,
      "todoList": todoList,
      "location": location,
      "uid": _uid,
      "name": name,
      "email": email,
      "fileImage": fileImage,
      "gender": gender,
      "birthday": birthday,
      "registrationDate": registrationDate,
      "notification": notification
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
