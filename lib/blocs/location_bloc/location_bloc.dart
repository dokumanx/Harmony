import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:harmony/blocs/location_bloc/location_event.dart';
import 'package:harmony/blocs/location_bloc/location_state.dart';
import 'location_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:harmony/repository/user_repository.dart';

class LocationBloc extends Bloc<LocationGetStarted, LocationGetSuccess> {
  LatLng initialPosition = LatLng(3, 4);
  LatLng currentLatLng;
  Location userLocation = Location();

  UserRepository _userRepository;
  UserDataRepository _userDataRepository;

  LocationBloc({UserRepository userRepository, UserDataRepository userDataRepository}): _userRepository=userRepository,
        _userDataRepository=userDataRepository;



  @override
  LocationGetSuccess get initialState =>
      LocationGetSuccess(saveUserCurrentLocation: initialPosition);

  Stream<LocationGetSuccess> mapEventToState(LocationEvent event) async*{
    if (event is LocationGetStarted) {
      userLocation.getLocation().then((l) {

        currentLatLng = LatLng(l.latitude, l.longitude);



      });

      yield LocationGetSuccess(saveUserCurrentLocation: currentLatLng);
    }
  }
}
