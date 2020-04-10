import 'package:flutter/material.dart';
import 'package:harmony/shared/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Add Progression Widget. ex. CircularProgressionIndicator()
      child: Loading(),
    );
  }
}
