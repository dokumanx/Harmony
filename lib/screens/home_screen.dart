import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_bloc_export.dart';
import 'dart:async';
import 'package:harmony/blocs/location_bloc/location_export.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({Key key, this.name}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationBloc _locationBloc;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer){
      _locationBloc.add(LocationGetStarted());
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    _locationBloc=BlocProvider.of<LocationBloc>(context);
    return BlocBuilder<LocationBloc, LocationGetSuccess>(builder: (context, state) {
    return MaterialApp(
      title: 'Home Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location:${(state as LocationGetSuccess).saveUserCurrentLocation}'),
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
              child: Text('Welcome ${widget.name}'),
            )
          ],
        ),
      ),
    );
  });
}}
