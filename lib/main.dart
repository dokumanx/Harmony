import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/bloc.dart';
import 'package:harmony/blocs/simple_bloc_delegate.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:harmony/screens/home/home_screen.dart';
import 'package:harmony/screens/login/login_screen.dart';
import 'package:harmony/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

//TODO: Activate Location Provider

  runApp(RepositoryProvider(
    create: (context) => UserRepository(),
    child: MainBlocs(),
  ));
}

class MainBlocs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        RepositoryProvider.of<UserRepository>(context);

    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted())),

//        BlocProvider(
//            create: (context) => LocationBloc()
//              ..add(
//                LocationGetStarted(),
//              )),
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen();
          }
          if (state is Authenticated) {
            return HomeScreen();
          }
          return SplashScreen();
        },
      ),
    );
  }
}
