import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_bloc_export.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({Key key, this.name}) : super(key: key);
  // TODO: Add tabs which include location, todos, and etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                  ..add(
                    LoggedOut(),
                  );
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text('Welcome $name'),
          )
        ],
      ),
    );
  }
}
