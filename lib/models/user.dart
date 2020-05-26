import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserType { patient, relative }

class User {
  final LatLng userLocation;
  final UserType userType;
  final String uid;
  final String name;
  // TODO : Check the type after you actually use this field.
  final String fileImage;
  final Gender gender;
  final String email;
  final DateTime registrationDate;

  //TODO: Change notification type from String to [UserNotification]
  final String notification;
  final DateTime birthday;
  User(
      {this.userLocation,
      this.userType,
      this.uid,
      this.name,
      this.email,
      this.fileImage,
      this.gender,
      this.birthday,
      this.registrationDate,
      this.notification});
}

enum Gender { male, female }
