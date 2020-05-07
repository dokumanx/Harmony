import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  final String name;

  const LocationScreen({Key key, this.name}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
//  LocationBloc _locationBloc;
//
//  @override
//  void initState() {
//    Timer.periodic(Duration(seconds: 5), (timer) {
//      _locationBloc.add(LocationGetStarted());
//    });
//    super.initState();
//  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  _locationBloc = BlocProvider.of<LocationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
    );
  }
}

//
//BlocBuilder<LocationBloc, LocationGetSuccess>(
//builder: (context, state) {
//return MaterialApp(
//title: 'Home Page',
//home: Scaffold(
//appBar: AppBar(
//title: Text(
//'Location:${(state as LocationGetSuccess).saveUserCurrentLocation}'),
//actions: <Widget>[
//IconButton(
//icon: Icon(Icons.exit_to_app),
//onPressed: () {
//BlocProvider.of<AuthenticationBloc>(context)
//..add(
//LoggedOut(),
//);
//})
//],
//),
//body: Column(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: <Widget>[
//Center(
//child: Text('Welcome ${widget.name}'),
//)
//],
//),
//),
//);
//});
