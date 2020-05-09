import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/register_bloc/bloc.dart';
import 'package:harmony/blocs/register_bloc/register_bloc.dart';

class SignInSwitch extends StatefulWidget {
  final Function toggleSwitch;

  const SignInSwitch({Key key, this.toggleSwitch}) : super(key: key);

  @override
  _SignInSwitchState createState() => _SignInSwitchState();
}

class _SignInSwitchState extends State<SignInSwitch> {
  bool isRelative = false;
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
          value: isRelative,
          onChanged: (value) {
            setState(() {
              isRelative = value;
              _registerBloc.add(UserTypeChanged(isRelative: isRelative));
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
