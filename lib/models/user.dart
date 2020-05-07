import 'package:flutter/material.dart';
import 'package:harmony/models/user_notification.dart';

enum Gender { male, female }
enum UserType { patient, relative }

class User {
  final UserType userType;
  final String uid;
  final String name;
  // TODO : Check the type after you actually use this field.
  final FileImage fileImage;
  final Gender gender;
  final String email;
  final DateTime registrationDate;
  final UserNotification notification;
  final DateTime birthday;
  User(
      {this.userType,
      this.uid,
      this.name,
      this.email,
      this.fileImage,
      this.gender,
      this.birthday,
      this.registrationDate,
      this.notification});
}
