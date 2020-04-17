import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


void main() => runApp(LocationPage());

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  //It must be gazo Location
  LatLng initialPosition = LatLng(3, 4);

  //This is for controlling of  camera position
  GoogleMapController mapController;

  //This is for  User Location
  Location userLocation = Location();

  // This save for user location
  LatLng saveUserCurrentLocation;


  //This is for Circle of current location of User
  Set<Circle> circles = HashSet<Circle>();


  // This is Id place for markers or circles
  int circleId = 1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loation Page of User',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "($saveUserCurrentLocation)",
            style: TextStyle(fontSize: 13),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition:
          CameraPosition(target: initialPosition, zoom: 10),
          mapType: MapType.terrain,
          onMapCreated: _onMapCreated,
          circles: circles,
          myLocationEnabled: true,
          onTap: _setCircles ,
        ),
        floatingActionButton: FloatingActionButton(

          onPressed: () {

            setState(() {
              circles.removeAll(circles);
            });

          },
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;



    userLocation.onLocationChanged.listen((l) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15)));

      setState(() {
        saveUserCurrentLocation = LatLng(l.latitude, l.longitude);
      });
    });

  }

  void _setCircles(LatLng onTapLocation) {
    final String circleIdVal = 'circle_id_$circleId';
    setState(() {
      circleId++;
    });
    circles.add(
      Circle(
          circleId: CircleId(circleIdVal),
          center: saveUserCurrentLocation,
          radius: 200,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeWidth: 3,
          strokeColor: Colors.red),
    );


  }
}