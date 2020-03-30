import 'package:flutter/material.dart';
import 'package:harmony/models/user.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget

    final User user = Provider.of<User>(context);
    return user == null ? Authenticate() : Home();
  }
}
