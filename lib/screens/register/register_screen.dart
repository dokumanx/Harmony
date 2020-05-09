import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/register_bloc/register_bloc.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:harmony/screens/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final bool _isPatient = false;
  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepository =
        RepositoryProvider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
              userRepository: _userRepository, isRelative: _isPatient),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
