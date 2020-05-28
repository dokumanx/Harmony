import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/user.dart';

class Patient extends User {
  final List<Relative> relatives;

  // TODO: Change todoList List to actual TodoList List
  final List<String> todoList;

  Patient(
      {this.relatives,
      this.todoList,
      LatLng userLocation,
      UserType userType,
      String uid,
      String name,
      String email,
      //TODO : Change fileImage type from String to FileImage
      String fileImage,
      Gender gender,
      DateTime birthday,
      DateTime registrationDate,
      String notification})
      : super(
            userLocation: userLocation,
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
    final jsonResponse = jsonDecode(snapshot.data["relatives"].toString());

    RelativeList relativeList = RelativeList.fromJson(jsonResponse);

    double latitude = snapshot["userLocation"][0].toDouble();
    double longitude = snapshot["userLocation"][1].toDouble();
    return Patient(
      relatives: relativeList.relatives,
      todoList: List<String>.from(snapshot.data["todoList"]),
      userLocation: LatLng(latitude, longitude) ?? LatLng(1, 1),
      userType: snapshot.data["userType"] == 'Patient'
          ? UserType.patient
          : UserType.relative,
      uid: snapshot.data["uid"],
      name: snapshot.data["name"],
      email: snapshot.data["email"],
      fileImage: snapshot.data["fileImage"],
      gender: snapshot.data["gender"] == 'Male' ? Gender.male : Gender.female,
      birthday: DateTime.parse(snapshot.data["birthday"]),
      registrationDate: DateTime.parse(snapshot.data["registrationDate"]),
      notification: snapshot.data["notification"],
    );
  }

  factory Patient.fromJson(Map<String, dynamic> parsedJson) {
    double latitude = parsedJson["userLocation"][0].toDouble();
    double longitude = parsedJson["userLocation"][1].toDouble();
    return Patient(
      name: parsedJson["name"] ?? "",
      email: parsedJson["email"] ?? "",
      userLocation: LatLng(latitude, longitude) ?? LatLng(1, 1),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "email": this.email,
        "userLocation": [
          this.userLocation.latitude,
          this.userLocation.longitude
        ],
      };
}

class PatientList {
  final List<Patient> patients;

  PatientList(this.patients);

  factory PatientList.fromJson(List<dynamic> parsedJson) {
    List<Patient> patients =
        List<Patient>.from(parsedJson.map((i) => Patient.fromJson(i)).toList());
    return PatientList(patients);
  }
}
