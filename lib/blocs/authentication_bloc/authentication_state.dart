import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayUid;

  const Authenticated(this.displayUid);
  @override
  List<Object> get props => [displayUid];

  @override
  String toString() => 'Authenticated {displayUid:$displayUid}';
}

class Unauthenticated extends AuthenticationState {}

class auth extends AuthenticationState{}
