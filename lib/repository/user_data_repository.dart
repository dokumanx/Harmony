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

  UserDataRepository({uid}) : _uid = uid;

  // TODO : Uid returns null
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  Future<void> setRelativeData(
      {List<Patient> patients,
      int faceModel,
      UserType userType,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    return await usersCollection.document(_uid).setData({
      "patients": patients ?? [],
      "faceModel": faceModel ?? 0,
      "userType": userType == UserType.patient ? "Patient" : "Relative",
      "uid": _uid,
      "name": name,
      "email": email ?? "unknown email",
      "fileImage": fileImage ?? "No image",
      "gender": gender ?? "Unknown",
      "birthday": birthday ?? '01.01.1990',
      "registrationDate": registrationDate ?? DateTime.now(),
      "notification": notification ?? "Not available",
    });
  }

  Future<void> setPatientData(
      {List<Relative> relatives,
      List<TodoList> todoList,
      UserType userType,
      Location location,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    return await usersCollection.document(_uid).setData({
      "relatives": relatives ?? [],
      "todoList": todoList ?? [],
      "location": location ?? "Not available",
      "userType": userType == UserType.patient ? "Patient" : "Relative",
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
    return usersCollection
        .document(_uid)
        .snapshots()
        .map(_relativeDataFromSnapshot);
  }

  Patient _patientDataFromSnaphot(DocumentSnapshot snapshot) {
    return Patient.patientFromDocumentSnapshot(snapshot);
  }

  Stream<Patient> get getPatient {
    return usersCollection
        .document(_uid)
        .snapshots()
        .map(_patientDataFromSnaphot);
  }

  Future<String> getUser() async {
    DocumentSnapshot userData = await usersCollection.document(_uid).get();
    return userData.data['userType'];
  }
}
