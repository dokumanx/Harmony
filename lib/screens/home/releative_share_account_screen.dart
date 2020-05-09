import 'package:flutter/material.dart';

class RelativeShareAccountScreen extends StatefulWidget {
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
