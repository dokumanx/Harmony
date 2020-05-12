import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony/models/relative.dart';
import 'package:harmony/models/user.dart';

class Patient extends User {
  final List<Relative> relatives;

  // TODO: Change todoList List to actual TodoList List
  final List<String> todoList;

  // TODO: Change location to actual Location
  final String location;

  Patient(
      {this.relatives,
      this.todoList,
      this.location,
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

    return Patient(
      relatives: relativeList.relatives,
      todoList: List<String>.from(snapshot.data["todoList"]),
      location: snapshot.data["location"],
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
    return Patient(
        name: parsedJson["name"] ?? "",
        email: parsedJson["email"] ?? "",
        userType: parsedJson["userType"] ?? "Unknown User Type"

        /// location: parsedJson["location"] ?? "",
        );
  }

  Map<String, dynamic> toJson() => {"name": this.name, "email": this.email};
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
