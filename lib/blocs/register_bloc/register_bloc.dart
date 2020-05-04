import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import './register_bloc_export.dart';
import '../../validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  bool isPatient;

  RegisterBloc({
    @required UserRepository userRepository,
    @required bool isPatient,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        isPatient = isPatient ?? false;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(Stream<RegisterEvent> events,
      Stream<RegisterState> Function(RegisterEvent) next) {
    final nonDebouncedEvents = events.where((event) {
      return ((event is! EmailChanged) && (event is! PasswordChanged));
    });
    final debouncedEvents = events.where((event) {
      return ((event is EmailChanged) || (event is PasswordChanged));
    }).debounceTime(Duration(milliseconds: 300));

    return super
        .transformEvents(nonDebouncedEvents.mergeWith([debouncedEvents]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is UserTypeChanged) {
      yield* _mapUserTypeChangedToState(event.isPatient);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapUserTypeChangedToState(bool isPatient) async* {
    this.isPatient = isPatient;
    yield state.copyWith();
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
          email: email, password: password, isPatient: isPatient);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
