import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/login_bloc/login_bloc.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:harmony/screens/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepository =
        RepositoryProvider.of<UserRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(),
      ),
    );
  }
}
