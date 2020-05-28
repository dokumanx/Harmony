import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      LatLng userLocation,
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
      // encode it to String with .toJson factory method.
      "userLocation": userLocation != null
          ? [userLocation.latitude, userLocation.longitude]
          : [1, 1],
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
      LatLng userLocation,
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
      "userLocation": userLocation != null
          ? [userLocation.latitude, userLocation.longitude]
          : [1, 1],
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
        .document(_userEmail)
        .snapshots()
        .map(_relativeDataFromSnapshot);
  }

  Patient _patientDataFromSnaphot(DocumentSnapshot snapshot) {
    return Patient.patientFromDocumentSnapshot(snapshot);
  }

  Stream<Patient> get getPatient {
    return usersCollection
        .document(_userEmail)
        .snapshots()
        .map(_patientDataFromSnaphot);
  }

  /// [Relative] CRUD operation
  Future<void> deleteRelative({String relativeEmail}) async {
    RelativeList relativeList;
    PatientList patientList;
    try {
      relativeList =
          await usersCollection.document(_userEmail).get().then((user) {
        /// 1) Get user [relatives] List
        final jsonResponse = jsonDecode(user["relatives"].toString());

        RelativeList relativeList = RelativeList.fromJson(jsonResponse);

        /// 2) Find relative with its email and delete
        relativeList.relatives
            .removeWhere((element) => element.email == relativeEmail);
        return relativeList;
      });
    } catch (e) {
      print("Error: " + e.toString());
    }

    try {
      patientList =
          await usersCollection.document(relativeEmail).get().then((user) {
        /// 1) Get user [patients] List
        final jsonResponse = jsonDecode(user["patients"].toString());

        PatientList patientList = PatientList.fromJson(jsonResponse);

        /// 2) Find patient with its email and delete
        patientList.patients
            .removeWhere((element) => element.email == _userEmail);
        return patientList;
      });
    } catch (e) {
      print("Error: " + e.toString());
    }

    /// 3) Encode object to String
    List<Map<String, dynamic>> responseRelative =
        relativeList.relatives.map((relative) => relative.toJson()).toList();

    String relativesJson = jsonEncode(responseRelative);

    List<Map<String, dynamic>> responsePatient =
        patientList.patients.map((patient) => patient.toJson()).toList();

    String patientsJson = jsonEncode(responsePatient);

    /// 4) Send it to FireStore
    await usersCollection.document(_userEmail).updateData({
      "relatives": relativesJson,
    });
    await usersCollection.document(relativeEmail).updateData({
      "patients": patientsJson,
    });
  }

  /// As a Patient
  Future<void> addRelative({String relativeEmail}) async {
    try {
      String relativeName;
      String patientName;

      List<double> relativeLocation;
      List<double> patientLocation;
      DocumentSnapshot documentSnapshot =
          await usersCollection.document(_userEmail).get();

      /// 1) Get user [relatives] List
      final jsonResponse =
          jsonDecode(documentSnapshot.data["relatives"].toString());

      RelativeList relativeList = RelativeList.fromJson(jsonResponse);

      bool isValidUser;

      /// Is it a valid user?
      try {
        DocumentSnapshot relativeSnapshot =
            await usersCollection.document(relativeEmail).get();
        patientName = documentSnapshot.data["name"].toString();
        patientLocation = List<double>.from(documentSnapshot
            .data["userLocation"]
            .map((e) => e.toDouble())
            .toList());
        if (relativeSnapshot.data['userType'] == 'Relative' ?? false) {
          relativeName = relativeSnapshot.data['name'];
          relativeLocation = List<double>.from(relativeSnapshot
              .data['userLocation']
              .map((e) => e.toDouble())
              .toList());

          isValidUser = true;
        } else {
          isValidUser = false;
        }
      } catch (e) {
        isValidUser = false;
      }

      if (isValidUser) {
        /// Check that if relative is already exist or not
        bool isRelativeSame = false;

        if (relativeList.relatives.length != 0) {
          for (Relative relative in relativeList.relatives) {
            if (relative.email == relativeEmail) {
              isRelativeSame = true;
            } else {
              isRelativeSame = false;
            }
          }
        }

        if (!isRelativeSame) {
          /// Add relative to the list

          relativeList.relatives.add(Relative(
            email: relativeEmail,
            name: relativeName,
            userLocation: LatLng(relativeLocation[0], relativeLocation[1]),
          ));

          PatientList patientList =
              await getPatientList(relativeEmail: relativeEmail);

          patientList.patients.add(Patient(
            email: _userEmail,
            name: patientName,
            userLocation: LatLng(patientLocation[0], patientLocation[1]),
          ));

          /// 3) Encode object to String
          List<Map<String, dynamic>> responseRelative = relativeList.relatives
              .map((relative) => relative.toJson())
              .toList();
          List<Map<String, dynamic>> responsePatient =
              patientList.patients.map((patient) => patient.toJson()).toList();

          String relativeJson = jsonEncode(responseRelative);
          String patientJson = jsonEncode(responsePatient);

          /// 4) Send it to FireStore
          await usersCollection.document(_userEmail).updateData({
            "relatives": relativeJson,
          });

          await usersCollection.document(relativeEmail).updateData({
            "patients": patientJson,
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// [Patient] CRUD operation
  Future<void> deletePatient({String patientEmail}) async {
    PatientList patientList;
    RelativeList relativeList;
    try {
      patientList =
          await usersCollection.document(_userEmail).get().then((user) {
        /// 1) Get user [PatientList]
        final jsonResponse = jsonDecode(user["patients"].toString());

        PatientList patientList = PatientList.fromJson(jsonResponse);

        /// 2) Find patient with its email and delete
        patientList.patients
            .removeWhere((element) => element.email == patientEmail);
        return patientList;
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      relativeList =
          await usersCollection.document(patientEmail).get().then((user) {
        /// 1) Get user [relatives] List
        final jsonResponse = jsonDecode(user["relatives"].toString());

        RelativeList relativeList = RelativeList.fromJson(jsonResponse);

        /// 2) Find relative with its email and delete
        relativeList.relatives
            .removeWhere((element) => element.email == _userEmail);
        return relativeList;
      });
    } catch (e) {
      print("Error: " + e.toString());
    }

    /// 3) Encode object to String
    List<Map<String, dynamic>> responsePatient =
        patientList.patients.map((patient) => patient.toJson()).toList();

    String patientJson = jsonEncode(responsePatient);

    List<Map<String, dynamic>> responseRelative =
        relativeList.relatives.map((relative) => relative.toJson()).toList();

    String relativeJson = jsonEncode(responseRelative);

    /// 4) Send it to FireStore
    await usersCollection.document(_userEmail).updateData({
      "patients": patientJson,
    });

    await usersCollection.document(patientEmail).updateData({
      "relatives": relativeJson,
    });
  }

  /// As a Relative
  Future<void> addPatient({String patientEmail}) async {
    try {
      String patientName;
      String relativeName;

      List<double> patientLocation;
      List<double> relativeLocation;

      DocumentSnapshot documentSnapshot =
          await usersCollection.document(_userEmail).get();

      /// 1) Get user [PatientList]
      final jsonResponse =
          jsonDecode(documentSnapshot.data["patients"].toString());

      PatientList patientList = PatientList.fromJson(jsonResponse);

      bool isValidUser;

      /// Is it a valid user?
      try {
        DocumentSnapshot patientSnapshot =
            await usersCollection.document(patientEmail).get();
        relativeName = documentSnapshot.data["name"].toString();
        relativeLocation = List<double>.from(documentSnapshot
            .data["userLocation"]
            .map((e) => e.toDouble())
            .toList());

        if (patientSnapshot.data['userType'] == 'Patient' ?? false) {
          patientName = patientSnapshot.data['name'];
          patientLocation = List<double>.from(patientSnapshot
              .data['userLocation']
              .map((e) => e.toDouble())
              .toList());

          isValidUser = true;
        } else {
          isValidUser = false;
        }
      } catch (e) {
        isValidUser = false;
        print("There is an error: " + e.toString());
      }

      if (isValidUser) {
        /// Check that if relative is already exist or not
        bool isPatientSame = false;
        if (patientList.patients.length != 0) {
          for (Patient patient in patientList.patients) {
            if (patient.email == patientEmail) {
              isPatientSame = true;
            } else {
              isPatientSame = false;
            }
          }
        }
        if (!isPatientSame) {
          /// Add relative and patients to the list

          patientList.patients.add(Patient(
            email: patientEmail,
            name: patientName,
            userLocation: LatLng(patientLocation[0], patientLocation[1]),
          ));

          RelativeList relativeList =
              await getRelativeList(patientEmail: patientEmail);

          relativeList.relatives.add(Relative(
            email: _userEmail,
            name: relativeName,
            userLocation: LatLng(relativeLocation[0], relativeLocation[1]),
          ));

          /// 3) Encode object to String
          List<Map<String, dynamic>> responsePatient =
              patientList.patients.map((patient) => patient.toJson()).toList();

          List<Map<String, dynamic>> responseRelative = relativeList.relatives
              .map((relative) => relative.toJson())
              .toList();

          String patientJson = jsonEncode(responsePatient);

          String relativeJson = jsonEncode(responseRelative);

          /// 4) Send it to FireStore
          await usersCollection.document(_userEmail).updateData({
            "patients": patientJson,
          });
          await usersCollection.document(patientEmail).updateData({
            "relatives": relativeJson,
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<PatientList> getPatientList({String relativeEmail}) async {
    PatientList patientList =
        await usersCollection.document(relativeEmail).get().then((user) {
      /// 1) Get user [PatientList]
      final jsonResponse = jsonDecode(user["patients"].toString());

      PatientList patientList = PatientList.fromJson(jsonResponse);

      return patientList;
    });

    return patientList;
  }

  Future<RelativeList> getRelativeList({String patientEmail}) async {
    RelativeList relativeList =
        await usersCollection.document(patientEmail).get().then((user) {
      /// 1) Get user [RelativeList]
      final jsonResponse = jsonDecode(user["relatives"].toString());

      RelativeList relativeList = RelativeList.fromJson(jsonResponse);

      return relativeList;
    });

    return relativeList;
  }

  Future<String> getUserType() async {
    await getUserEmail();
    DocumentSnapshot userData =
        await usersCollection.document(_userEmail).get();
    return userData.data['userType'];
  }
}
