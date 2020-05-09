import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:harmony/models/location.dart';
import 'package:harmony/models/patient.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/models/user_notification.dart';

class UserDataRepository {
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  String _userEmail;

  Future<String> getUserEmail() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    _userEmail = _user.email;
    return _userEmail;
  }

  Future<void> setRelativeData(
      {List<Patient> patients,
      int faceModel,
      UserType userType,
        String uid,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    await getUserEmail();
    return await usersCollection.document(_userEmail).setData({
      "patients": patients ?? [],
      "faceModel": faceModel ?? 0,
      "userType": userType == UserType.patient ? "Patient" : "Relative",
      "uid": uid,
      "name": name ?? email,
      "email": email,
      "fileImage": fileImage ?? "No image",
      "gender": gender ?? "Unknown",
      "birthday": birthday ?? '1990-01-01',
      "registrationDate": registrationDate ?? DateTime.now().toIso8601String(),
      "notification": notification ?? "Not available",
    });
  }

  Future<void> setPatientData(
      {List<Relative> relatives,
      List<TodoList> todoList,
      UserType userType,
      Location location,
        String uid,
      String name,
      String email,
      FileImage fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      UserNotification notification}) async {
    await getUserEmail();
    return await usersCollection.document(_userEmail).setData({
      "relatives": relatives ?? [],
      "todoList": todoList ?? [],
      "location": location ?? "Not available",
      "userType": userType == UserType.patient ? "Patient" : "Relative",
      "uid": uid,
      "name": name ?? email,
      "email": email,
      "fileImage": fileImage ?? "No image",
      "gender": gender ?? "Unknown",
      "birthday": birthday ?? '1990-01-01',
      "registrationDate": registrationDate ?? DateTime.now().toIso8601String(),
      "notification": notification ?? "Not available"
    });
  }

  Relative _relativeDataFromSnapshot(DocumentSnapshot snapshot) {
    return Relative.relativeFromDocumentSnapshot(snapshot);
  }

  Stream<Relative> get getRelative {
    return usersCollection
        .document()
        .snapshots()
        .map(_relativeDataFromSnapshot);
  }

  Patient _patientDataFromSnaphot(DocumentSnapshot snapshot) {
    return Patient.patientFromDocumentSnapshot(snapshot);
  }

  //TODO: Null döndürüyo
  Stream<Patient> get getPatient {
    return usersCollection
        .document(_userEmail)
        .snapshots()
        .map(_patientDataFromSnaphot);
  }

  Future<String> getUserType() async {
    await getUserEmail();
    DocumentSnapshot userData =
    await usersCollection.document(_userEmail).get();
    return userData.data['userType'];
  }
}
