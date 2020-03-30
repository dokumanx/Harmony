import 'package:flutter/material.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/screens/authenticate/form_validation.dart';
import 'package:harmony/services/database.dart';
import 'package:harmony/shared/constants.dart';
import 'package:harmony/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4', '5'];
  final FormValidation _formValidation = FormValidation();

  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) => _formValidation.validateName(val),
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  //dropdown
                  DropdownButtonFormField(
                    value: _currentSugar ?? '${userData.sugars}',
                    onChanged: (val) {
                      setState(() => _currentSugar = val);
                    },
                    items: sugars
                        .map((sugar) => DropdownMenuItem(
                              value: sugar,
                              child: Text("$sugar sugars"),
                            ))
                        .toList(),
                  ),

                  //slider
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.round();
                      });
                    },
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                  ),

                  //Button
                  RaisedButton(
                    color: Colors.pink,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: userData.uid).updateUserData(
                            sugars: _currentSugar ?? userData.sugars,
                            name: _currentName ?? userData.name,
                            strength: _currentStrength ?? userData.strength);
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
