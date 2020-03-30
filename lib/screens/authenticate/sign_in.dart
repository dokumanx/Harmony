import 'package:flutter/material.dart';
import 'package:harmony/services/auth_service.dart';
import 'package:harmony/shared/constants.dart';
import 'package:harmony/shared/loading.dart';

import 'form_validation.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();

  final Function toggleView;

  SignIn({this.toggleView});
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  FormValidation formValidation = FormValidation();
  // text state
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
              title: Text('Sign in to Brew Crew'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
              child: ListView(
                children: <Widget>[
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
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
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
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => isLoading = true);
                              dynamic user = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (user == null) {
                                setState(() {
                                  isLoading = false;
                                  error = 'Please supply valid email.';
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
