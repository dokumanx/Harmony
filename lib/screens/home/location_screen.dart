import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location System"),
      ),
      body: UserLocationMap(),
    );
  }
}

// ignore: must_be_immutable
class UserLocationMap extends StatefulWidget {
  @override
  _UserLocationMapState createState() => _UserLocationMapState();
}

class _UserLocationMapState extends State<UserLocationMap> {
  GoogleMapController mapController;
  Geolocator geoLocator = Geolocator();
  Position _currentPosition = Position(longitude: 23.2323, latitude: 18.2342);

  @override
  void initState() {
    super.initState();
  }

  Future<Position> getCurrentLocation() async {
    return await geoLocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
              ),
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width - 70,
            top: MediaQuery.of(context).size.height - 210,
            child: FloatingActionButton(
              tooltip: "Show Current Location",
              child: Icon(FontAwesomeIcons.locationArrow),
              onPressed: () async {
                _currentPosition = await getCurrentLocation();
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 12.0)));
                List<Placemark> placemark =
                    await geoLocator.placemarkFromCoordinates(
                        _currentPosition.longitude, _currentPosition.latitude);
                print("Province: " +
                    placemark[0].subAdministrativeArea +
                    "\nName: " +
                    placemark[0].position.toString());
              },
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width - 70,
            top: MediaQuery.of(context).size.height - 285,
            child: FloatingActionButton(
              tooltip: "Find Users",
              child: Icon(FontAwesomeIcons.searchLocation),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
