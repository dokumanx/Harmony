import 'package:equatable/equatable.dart';

abstract class SharingAccountState extends Equatable {
  const SharingAccountState();
}

class SharingAccountInitialState extends SharingAccountState {
  @override
  List<Object> get props => [];
}

class SharingAccountSuccessState extends SharingAccountState {
  final String email;

  SharingAccountSuccessState({this.email});

  @override
  List<Object> get props => [email];
}

class SharingAccountInProgressState extends SharingAccountState {
  @override
  List<Object> get props => [];
}

class SharingAccountFailureState extends SharingAccountState {
  final String error;

  SharingAccountFailureState({this.error});
  @override
  List<Object> get props => [error];
}
