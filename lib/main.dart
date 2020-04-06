import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_event.dart';
import 'package:harmony/blocs/simple_bloc_delegate.dart';
import 'package:harmony/repository/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: MyApp(
        userRepository: userRepository,
      )));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
