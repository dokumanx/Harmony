import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {}

class InitialLocationState extends LocationState {
  @override
  List<Object> get props => null;
}

class LocationStateLoading extends LocationState {
  @override
  List<Object> get props => null;
}

class LocationStateSuccess extends LocationState {
  @override
  List<Object> get props => null;
}

class LocationStateFailure extends LocationState {
  @override
  List<Object> get props => null;
}
