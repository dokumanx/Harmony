import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harmony/models/patient.dart';
import 'package:harmony/models/user.dart';

class Relative extends User {
  final List<Patient> patients;
  final int faceModel;

  Relative(
      {this.patients,
      this.faceModel,
      UserType userType,
      LatLng userLocation,
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

  factory Relative.relativeFromDocumentSnapshot(DocumentSnapshot snapshot) {
    final jsonResponse = jsonDecode(snapshot.data["patients"].toString());

    PatientList patientList = PatientList.fromJson(jsonResponse);

    List<double> toLatLng = snapshot.data["userLocation"]
        .toString()
        .split(',')
        .map((e) => double.parse(e))
        .toList();

    return Relative(
      patients: patientList.patients,
      faceModel: snapshot.data["faceModel"] ?? 0,
      userType: snapshot.data["userType"] == 'Patient'
          ? UserType.patient
          : UserType.relative,
      userLocation: LatLng(toLatLng[0], toLatLng[1]) ?? LatLng(1, 1),
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

  factory Relative.fromJson(Map<String, dynamic> parsedJson) {
    List<double> toLatLng = parsedJson["userLocation"]
        .toString()
        .split(',')
        .map((e) => double.parse(e))
        .toList();
    return Relative(
      name: parsedJson["name"] ?? "",
      email: parsedJson["email"] ?? "",
      userLocation: LatLng(toLatLng[0], toLatLng[1]) ?? LatLng(1, 1),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "email": this.email,
        "userLocation":
            "${this.userLocation.latitude},${this.userLocation.longitude}",
      };
}

class RelativeList {
  final List<Relative> relatives;

  RelativeList(this.relatives);

  factory RelativeList.fromJson(List<dynamic> parsedJson) {
    List<Relative> relatives = List<Relative>.from(
        parsedJson.map((i) => Relative.fromJson(i)).toList());
    return RelativeList(relatives);
  }
}
