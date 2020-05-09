import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony/models/user.dart';

class Relative extends User {
  final List<String> patients;
  final int faceModel;

  Relative(
      {this.patients,
      this.faceModel,
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

  factory Relative.relativeFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Relative(
      patients: List<String>.from(snapshot.data["patients"]),
      faceModel: snapshot.data["faceModel"],
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
}
