import 'package:flutter/material.dart';
import 'package:harmony/services/auth_service.dart';
import 'package:harmony/shared/constants.dart';
import 'package:harmony/shared/loading.dart';

import 'form_validation.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();

  final Function toggleView;

  Register({this.toggleView});
}

class _RegisterState extends State<Register> {
  AuthService _auth = AuthService();

  FormValidation formValidation = FormValidation();

  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Register to Brew Crew'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Sign in'))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
              child: ListView(children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => formValidation.validateEmail(val),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) =>
                            formValidation.validatePassword(val),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => isLoading = true);
                            dynamic user = await _auth
                                .registerWithEmailAndPasword(email, password);

                            if (user == null) {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                  error = 'Please supply valid email.';
                                });
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 100.0,
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
  }
}
