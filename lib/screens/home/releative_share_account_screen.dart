import 'package:flutter/material.dart';
import 'package:harmony/repository/user_data_repository.dart';

class RelativeShareAccountScreen extends StatefulWidget {
  final UserDataRepository userDataRepository;

  const RelativeShareAccountScreen({ this.userDataRepository}) ;

  @override
  _RelativeShareAccountScreenState createState() =>
      _RelativeShareAccountScreenState();
}

class _RelativeShareAccountScreenState
    extends State<RelativeShareAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Relative Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
