import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:harmony/repository/user_repository.dart';

import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        assert(userRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final bool isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        yield Authenticated(await _userRepository.getUserId());
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield Unauthenticated();
      print(e);
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUserId());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    await _userRepository.singOut();
  }
}
