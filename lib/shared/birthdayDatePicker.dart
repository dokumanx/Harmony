import 'package:flutter/material.dart';

class BirthdayDatePicker extends StatefulWidget {
  @override
  _BirthdayDatePickerState createState() => _BirthdayDatePickerState();
}

class _BirthdayDatePickerState extends State<BirthdayDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.0,
        width: 370.0,
        child: Card(
          child: ListTile(
            title: Text('BirthDay of you'),
          ),
        ));
  }
}
