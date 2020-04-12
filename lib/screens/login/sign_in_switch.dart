import 'package:flutter/material.dart';

class SignInSwitch extends StatefulWidget {
  final Function toggleSwitch;

  const SignInSwitch({Key key, this.toggleSwitch}) : super(key: key);

  @override
  _SignInSwitchState createState() => _SignInSwitchState();
}

class _SignInSwitchState extends State<SignInSwitch> {
  bool isPatient = false;
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
            });
          },
        ),
        Text('As Relative')
      ],
    );
  }
}
