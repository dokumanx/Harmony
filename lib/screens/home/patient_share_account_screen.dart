import 'package:flutter/material.dart';

class PatientShareAccountScreen extends StatefulWidget {
  @override
  _PatientShareAccountScreenState createState() =>
      _PatientShareAccountScreenState();
}

class _PatientShareAccountScreenState extends State<PatientShareAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Patient Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
