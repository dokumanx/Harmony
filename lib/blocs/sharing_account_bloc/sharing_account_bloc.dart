import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/repository/user_data_repository.dart';

import './bloc.dart';

class SharingAccountBloc
    extends Bloc<SharingAccountEvent, SharingAccountState> {
  final UserDataRepository _userDataRepository;

  SharingAccountBloc({userDataRepository})
      : _userDataRepository = userDataRepository,
        assert(userDataRepository != null);

  @override
  SharingAccountState get initialState => SharingAccountInitialState();

  @override
  Stream<SharingAccountState> mapEventToState(
    SharingAccountEvent event,
  ) async* {
    if (event is SharingAccountStarted) {
      yield* _mapSharingAccountStartedToState();
    }
    if (event is SharingAccountAdded) {
      yield* _mapSharingAccountAddedToState(
          email: event.email, userType: event.userType);
    }
    if (event is SharingAccountDeleted) {
      yield* _mapSharingAccountDeletedToState(
          email: event.email, userType: event.userType);
    }
  }

  Stream<SharingAccountState> _mapSharingAccountStartedToState() async* {
    yield SharingAccountInitialState();
  }

  Stream<SharingAccountState> _mapSharingAccountAddedToState(
      {String email, UserType userType}) async* {
    yield SharingAccountInProgressState();

    if (userType == UserType.relative) {
      try {
        await _userDataRepository.addRelative(relativeEmail: email);
        yield SharingAccountSuccessState(email: email);
      } catch (e) {
        yield SharingAccountFailureState(error: e.toString());
        print(e.toString());
      }
    } else if (userType == UserType.patient) {
      try {
        await _userDataRepository.addPatient(patientEmail: email);
        yield SharingAccountSuccessState(email: email);
      } catch (e) {
        yield SharingAccountFailureState();
        print(e.toString());
      }
    }
  }

  Stream<SharingAccountState> _mapSharingAccountDeletedToState(
      {String email, UserType userType}) async* {
    yield SharingAccountInProgressState();
    if (userType == UserType.relative) {
      try {
        await _userDataRepository.deleteRelative(relativeEmail: email);
        yield SharingAccountSuccessState(email: email);
      } catch (e) {
        yield SharingAccountFailureState();
        print(e.toString());
      }
    } else if (userType == UserType.patient) {
      try {
        await _userDataRepository.deletePatient(patientEmail: email);
        yield SharingAccountSuccessState(email: email);
      } catch (e) {
        yield SharingAccountFailureState();
        print(e.toString());
      }
    }
  }
}
