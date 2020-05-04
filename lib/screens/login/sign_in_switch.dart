import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/register_bloc/register_bloc.dart';
import 'package:harmony/blocs/register_bloc/register_bloc_export.dart';

class SignInSwitch extends StatefulWidget {
  final Function toggleSwitch;

  const SignInSwitch({Key key, this.toggleSwitch}) : super(key: key);

  @override
  _SignInSwitchState createState() => _SignInSwitchState();
}

class _SignInSwitchState extends State<SignInSwitch> {
  bool isPatient = false;
  RegisterBloc _registerBloc;
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('As Patient'),
        Switch(
          value: isPatient,
          onChanged: (value) {
            setState(() {
              isPatient = value;
              _registerBloc.add(UserTypeChanged(isPatient: isPatient));
            });
          },
          activeColor: Colors.purple[200],
          inactiveThumbColor: Colors.red[200],
          inactiveTrackColor: Colors.red[100],
        ),
        Text('As Relative')
      ],
    );
  }
}
