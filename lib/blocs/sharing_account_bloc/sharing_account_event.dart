import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harmony/models/user.dart';

abstract class SharingAccountEvent extends Equatable {
  const SharingAccountEvent();

  @override
  List<Object> get props => [];
}

class SharingAccountStarted extends SharingAccountEvent {
  @override
  List<Object> get props => null;
}

class SharingAccountAdded extends SharingAccountEvent {
  final String email;
  final UserType userType;

  SharingAccountAdded({@required this.email, @required this.userType});

  @override
  List<Object> get props => [email, userType];

  @override
  String toString() => 'AccountAdded {Email: $email, User Type: $userType}';
}

class SharingAccountDeleted extends SharingAccountEvent {
  final String email;
  final UserType userType;

  SharingAccountDeleted({this.email, this.userType});

  @override
  List<Object> get props => [email, userType];

  @override
  String toString() => 'AccountDeleted {Email: $email, User Type: $userType}';
}
