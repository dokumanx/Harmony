import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  @override
  LocationState get initialState => InitialLocationState();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
